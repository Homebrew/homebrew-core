class GnustepBase < Formula
  desc "Library of general-purpose, non-graphical Objective C objects"
  homepage "https://github.com/gnustep/libs-base"
  url "https://github.com/gnustep/libs-base/releases/download/base-1_29_0/gnustep-base-1.29.0.tar.gz"
  sha256 "fa58eda665c3e0b9c420dc32bb3d51247a407c944d82e5eed1afe8a2b943ef37"
  license "GPL-2.0-or-later"

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
    sha256 cellar: :any,                 arm64_ventura:  "f7b268cf13fbe24b2471b778c42c38c2000e05d08113e7a7aa28d34385a85a26"
    sha256 cellar: :any,                 arm64_monterey: "ef39d1e12dcce4df899511dbc8bef26420873c8ff067a645e2f3771d4ffba68c"
    sha256 cellar: :any,                 arm64_big_sur:  "80743312a107c370f518900583f95c359599b8a164cd995b8ec5694a8835be98"
    sha256 cellar: :any,                 ventura:        "b2af7e946b32130040a310ba179cc18b4e71a084928585e165077556edd3fe48"
    sha256 cellar: :any,                 monterey:       "9f1293102d1932e18e70d2fb7c49d2b768a98f94c9c9147b4384a61bbf0a90a6"
    sha256 cellar: :any,                 big_sur:        "c5635161e124a5bad33bb9acfc47abc3bc66b3a32d0f571296e468ffe73f92f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "403e69d3d5ab1ed07a7e36e6254af6420c5fed69d386faa033ffa51a2c41939b"
  end

  depends_on "gnustep-make" => :build
  depends_on "pkg-config" => :build
  depends_on "gmp"
  depends_on "gnutls"

  uses_from_macos "icu4c", since: :monterey
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
