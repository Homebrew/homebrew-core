class GnustepBase < Formula
  desc "Library of general-purpose, non-graphical Objective C objects"
  homepage "https://github.com/gnustep/libs-base"
  url "https://github.com/gnustep/libs-base/releases/download/base-1_31_1/gnustep-base-1.31.1.tar.gz"
  sha256 "e7546f1c978a7c75b676953a360194a61e921cb45a4804497b4f346a460545cd"
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

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b4e784229fba45e3cf7e766550621836a32ca09fffa5f4bbb6de15a4a94b1c05"
    sha256 cellar: :any,                 arm64_sequoia: "5ff4a3360ffad358e87d9c556f41ccfd5e6fe44dfda235056a2129cf83807417"
    sha256 cellar: :any,                 arm64_sonoma:  "d57d4f9a586463bb70761168d02c4998603d85b0c8283811a09e1043817791aa"
    sha256 cellar: :any,                 sonoma:        "9a4d52b364feff116b951a9791795be6c008e3b59fafe660025da9cb48e9595b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9ad9b2062112680e37f2e0c66d37e04babfa46ccfb8240ba9ce47c831c450d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb5b281a17b65f980415c499f9cccacde252a20b0be65a26a114bd7e4f500c06"
  end

  depends_on "gnustep-make" => :build
  depends_on "pkgconf" => :build
  depends_on "gmp"
  depends_on "gnutls"

  uses_from_macos "llvm" => :build
  uses_from_macos "libffi"
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "zlib"

  on_system :linux, macos: :big_sur_or_older do
    depends_on "icu4c@78"
  end

  on_linux do
    depends_on "libobjc2"
    depends_on "zstd"
    fails_with :gcc
  end

  def install
    ENV.prepend_path "PATH", Formula["gnustep-make"].libexec
    ENV["GNUSTEP_MAKEFILES"] = if OS.mac?
      Formula["gnustep-make"].opt_prefix/"Library/GNUstep/Makefiles"
    else
      Formula["gnustep-make"].share/"GNUstep/Makefiles"
    end

    if OS.mac? && MacOS.version > :big_sur && (sdk = MacOS.sdk_path_if_needed)
      ENV["ICU_CFLAGS"] = "-I#{sdk}/usr/include"
      ENV["ICU_LIBS"] = "-L#{sdk}/usr/lib -licucore"

      # Fix compile with newer Clang
      ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403
    end

    # Don't let gnustep-base try to install its makefiles in cellar of gnustep-make.
    inreplace "Makefile.postamble", "$(DESTDIR)$(GNUSTEP_MAKEFILES)", share/"GNUstep/Makefiles"

    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install", "GNUSTEP_HEADERS=#{include}",
                              "GNUSTEP_LIBRARY=#{share}",
                              "GNUSTEP_LOCAL_DOC_MAN=#{man}",
                              "GNUSTEP_LOCAL_LIBRARIES=#{lib}",
                              "GNUSTEP_LOCAL_TOOLS=#{bin}"
  end

  test do
    (testpath/"test.xml").write <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <test>
        <text>I'm an XML document.</text>
      </test>
    XML

    assert_match "Validation failed: no DTD found", shell_output("#{bin}/xmlparse test.xml 2>&1")
  end
end
