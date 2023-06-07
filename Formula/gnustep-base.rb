class GnustepBase < Formula
  desc "Library of general-purpose, non-graphical Objective C objects"
  homepage "https://github.com/gnustep/libs-base"
  url "https://github.com/gnustep/libs-base/releases/download/base-1_28_0/gnustep-base-1.28.0.tar.gz"
  sha256 "c7d7c6e64ac5f5d0a4d5c4369170fc24ed503209e91935eb0e2979d1601039ed"
  license "GPL-2.0-or-later"
  revision 2

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
    sha256 cellar: :any,                 arm64_ventura:  "8321c4f4c88e7084055ffdd4a47d5f792379d49e662aa6b3d8f586e28ffd1432"
    sha256 cellar: :any,                 arm64_monterey: "2be5d01c301c2ddd08517954ddabd6c848ef2d2068ac3a368c2ceef6a373434b"
    sha256 cellar: :any,                 arm64_big_sur:  "eefb5b924796bbed2363208020fec26978879041d027e0f714bb9aa8eeb29e57"
    sha256 cellar: :any,                 ventura:        "fccc6827af7851073317a850ddb412d9dda225d19a1f80831003f8f0c9154803"
    sha256 cellar: :any,                 monterey:       "6d2b9e709bfaeabd827fa8ee695a1b52c1d5736a7208574183756a5f9cd9dd45"
    sha256 cellar: :any,                 big_sur:        "fcd6ceeba0b0ab08f26f555e43a847e4d7fccedd2174403f98948d9079b31898"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8469b84215c32e04a27175e5c787e3b12dbdc80f55f5f2d6132f14e5b8772a75"
  end

  depends_on "gnustep-make" => :build
  depends_on "gmp"
  depends_on "gnutls"

  # While libobjc2 is built with clang on Linux, it does not use any LLVM runtime libraries.
  uses_from_macos "llvm" => [:build, :test]
  uses_from_macos "icu4c"
  uses_from_macos "libffi"
  uses_from_macos "libxslt"

  on_linux do
    depends_on "libobjc2"
  end

  # Clang must be used on Linux because GCC Objective-C support is insufficient.
  fails_with :gcc

  def install
    ENV.prepend_path "PATH", Formula["gnustep-make"].libexec
    ENV["GNUSTEP_MAKEFILES"] = if OS.mac?
      Formula["gnustep-make"].opt_prefix/"Library/GNUstep/Makefiles"
    else
      Formula["gnustep-make"].share/"GNUstep/Makefiles"
    end

    if OS.mac?
      ENV["ICU_CFLAGS"] = "-I#{MacOS.sdk_path}/usr/include"
      ENV["ICU_LIBS"] = "-L#{MacOS.sdk_path}/usr/lib -licucore"
    end

    # Don't let gnustep-base try to install its makefiles in cellar of gnustep-make.
    inreplace "Makefile.postamble", "$(DESTDIR)$(GNUSTEP_MAKEFILES)", share/"GNUstep/Makefiles"

    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install",
      "GNUSTEP_HEADERS=#{include}",
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
