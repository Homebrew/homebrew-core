class GnustepBase < Formula
  desc "Library of general-purpose, non-graphical Objective C objects"
  homepage "https://github.com/gnustep/libs-base"
  url "https://github.com/gnustep/libs-base/releases/download/base-1_28_0/gnustep-base-1.28.0.tar.gz"
  sha256 "c7d7c6e64ac5f5d0a4d5c4369170fc24ed503209e91935eb0e2979d1601039ed"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4327477c03d1552b51d19fb5a3c81d52ababcd6cb9a14daf2e1ff7194a67d23e"
    sha256 cellar: :any,                 arm64_monterey: "cf7a07aa822697b5f15a493422b07cf086408ce45849b75d64b8ffc216cef105"
    sha256 cellar: :any,                 arm64_big_sur:  "d5733e00bb51841c86c82dff375c4ce0466dabb0c59975a6816a6b633321685f"
    sha256 cellar: :any,                 ventura:        "1dac9623aa322cdc307f5ee2a0a577106e06ed6192cb8ee3470a22302d3b7602"
    sha256 cellar: :any,                 monterey:       "5d678fc6a28241da2da40c5e57b1ea3826d503863a76a02accee96d1e67e7c94"
    sha256 cellar: :any,                 big_sur:        "d68aa3d0c33fcdd56cb24aac6725b886a2921390a4cafcf66ef2946120d691be"
    sha256 cellar: :any,                 catalina:       "b27fd65268dbd46b34cebb39a173a1c1c0f7e9ff5088f02e57e2e50faae7cb0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83c39b1524d8a326f22bb2082d7ed326a2b4cabd927a79b11ab786970b331d19"
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
