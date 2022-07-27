class GnustepBase < Formula
  desc "Library of general-purpose, non-graphical Objective C objects"
  homepage "https://github.com/gnustep/libs-base"
  url "https://github.com/gnustep/libs-base/releases/download/base-1_28_0/gnustep-base-1.28.0.tar.gz"
  sha256 "c7d7c6e64ac5f5d0a4d5c4369170fc24ed503209e91935eb0e2979d1601039ed"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "06f520ea70f310d6e9a60c7a4282bb01f3aa00ac2809f1fe066d9a866f5d842d"
    sha256 cellar: :any,                 arm64_big_sur:  "1ed40ca235f00fd679d2cde5f913392227df66b2453915df0a0b841662859ed5"
    sha256 cellar: :any,                 monterey:       "01b2126e3e693efae4ab141ecf52540d67dd2c8b2d2c5e9814856271e43f971b"
    sha256 cellar: :any,                 big_sur:        "8c4b5a57e5b030d29db38a2aa445abb7f77dff91567850a4370c171511b9e90e"
    sha256 cellar: :any,                 catalina:       "ff6c552ba77b712323250d2ad3a625a0a4e91f5d7b4c28f8074e605c525d6158"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "840187316351f0872d3c6a3721203939e0229b89f35ec55e1c1ff662a1f5f156"
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
