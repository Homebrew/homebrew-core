class GnustepBase < Formula
  desc "Library of general-purpose, non-graphical Objective C objects"
  homepage "https://github.com/gnustep/libs-base"
  url "https://github.com/gnustep/libs-base/releases/download/base-1_28_0/gnustep-base-1.28.0.tar.gz"
  sha256 "c7d7c6e64ac5f5d0a4d5c4369170fc24ed503209e91935eb0e2979d1601039ed"
  license "GPL-2.0-or-later"
  revision 3

  livecheck do
    url :stable
    regex(/^\D*?(\d+(?:[._]\d+)+)$/i)
    strategy :github_latest do |json, regex|
      match = json["tag_name"]&.match(regex)
      next if match.blank?

      match[1].tr("_", ".")
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9b9c44a7b2c574388b1137624abca0fb7b840184f3d20de09e44b46370b0a31f"
    sha256 cellar: :any,                 arm64_monterey: "b9e9859e4b4f45972f7a4ad3bac1e5186239d7cc28bc956ff384d06c4967c299"
    sha256 cellar: :any,                 arm64_big_sur:  "733a9754a371902290f84f8aa395aefd08c3fd4c760fbb66ba891002bd78aa8c"
    sha256 cellar: :any,                 ventura:        "eb5ccca2b5dba081540bc1422d071fa9899d19935c7b3565d4dc9fac424f2c46"
    sha256 cellar: :any,                 monterey:       "150d627aafdb6c08033e39864b78c7971ea7b2d66cba7ff1bf27a10816d1add1"
    sha256 cellar: :any,                 big_sur:        "48e2dde1f3b57c87f5a8af140873487f51139b2363540845fc66ca03b15b3869"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0fc6e0c758b95f480b7504410f77bdf3b33db270baf0f57cedcf174ca1cad760"
  end

  depends_on "gnustep-make" => :build
  depends_on "pkg-config" => :build
  depends_on "gmp"
  depends_on "gnutls"

  uses_from_macos "icu4c"
  uses_from_macos "libffi"
  uses_from_macos "libxslt"

  on_linux do
    # Needs to be built with Clang for Objective-C, but fails with LLVM 16.
    depends_on "llvm@15" => :build
    depends_on "libobjc2"
  end

  # Fix build with new libxml2.
  # https://github.com/gnustep/libs-base/pull/295
  patch do
    url "https://github.com/gnustep/libs-base/commit/37913d006d96a6bdcb963f4ca4889888dcce6094.patch?full_index=1"
    sha256 "57e353fedc530c82036184da487c25e006a75a4513e2a9ee33e5109446cf0534"
  end

  def install
    ENV.prepend_path "PATH", Formula["gnustep-make"].libexec
    ENV["GNUSTEP_MAKEFILES"] = if OS.mac?
      Formula["gnustep-make"].opt_prefix/"Library/GNUstep/Makefiles"
    else
      ENV.clang # To use `llvm@15` clang
      Formula["gnustep-make"].share/"GNUstep/Makefiles"
    end

    if OS.mac? && (sdk = MacOS.sdk_path_if_needed)
      ENV["ICU_CFLAGS"] = "-I#{sdk}/usr/include"
      ENV["ICU_LIBS"] = "-L#{sdk}/usr/lib -licucore"
      # Workaround for implicit function declaration error.
      ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version == 1403
    end

    # Don't let gnustep-base try to install its makefiles in cellar of gnustep-make.
    inreplace "Makefile.postamble", "$(DESTDIR)$(GNUSTEP_MAKEFILES)", share/"GNUstep/Makefiles"

    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install", "GNUSTEP_HEADERS=#{include}",
                              "GNUSTEP_LIBRARY=#{share}",
                              "GNUSTEP_LOCAL_DOC_MAN=#{man}",
                              "GNUSTEP_LOCAL_LIBRARIES=#{lib}",
                              "GNUSTEP_LOCAL_TOOLS=#{bin}"
  end

  test do
    (testpath/"test.xml").write <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <test>
        <text>I'm an XML document.</text>
      </test>
    EOS

    assert_match "Validation failed: no DTD found", shell_output("#{bin}/xmlparse test.xml 2>&1")
  end
end
