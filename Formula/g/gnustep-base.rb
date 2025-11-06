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
    sha256 cellar: :any,                 arm64_tahoe:   "8c99d42136e8fdbb022aa2eb1395d96018c1be0055c3bef6cabeb489dd552323"
    sha256 cellar: :any,                 arm64_sequoia: "1e5a8582ead69977c155a8ac3f0afc01b96ae6d82012432fe496a54c4a94dfbb"
    sha256 cellar: :any,                 arm64_sonoma:  "1d3c8a9c13c7fdfe40eebc6a35fb88e97ea220e8842ba5aace4373609a328e07"
    sha256 cellar: :any,                 sonoma:        "c602bc642e5006f38c720be4e0e1b46f7bc35850e22ffd1ebf3f19b4ac5d25ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f8574f9b40f42da356a43700591ae8111c084194ab5b3a8e28406f9c51e70e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c59eca62140d4b067850a68df92e81ed3397e82136faca8e9d146512839d1371"
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
