class GnustepBase < Formula
  desc "Library of general-purpose, non-graphical Objective C objects"
  homepage "https://github.com/gnustep/libs-base"
  url "https://github.com/gnustep/libs-base/releases/download/base-1_31_1/gnustep-base-1.31.1.tar.gz"
  sha256 "e7546f1c978a7c75b676953a360194a61e921cb45a4804497b4f346a460545cd"
  license "GPL-2.0-or-later"
  revision 1

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
    sha256 cellar: :any,                 arm64_sequoia: "022cbc646ea0a05743c51cb7d804549b78d53bd2b9900113421ba9b37853e515"
    sha256 cellar: :any,                 arm64_sonoma:  "c87551242fea4d1739d7c651a590113ef97ec2f25a7e5ed3067ef4d5d382d62b"
    sha256 cellar: :any,                 arm64_ventura: "32af6ef0e1a74f765fb361e8012b32a0f8b0d47d8d0ccd3f37eb616992c554e0"
    sha256 cellar: :any,                 sonoma:        "7ca4a56508b6eaa4fb8ba7d3f111795bf180588709537e3dda6657a86925b328"
    sha256 cellar: :any,                 ventura:       "c396d40c48b47283351eff5a976ad62cb4d11a3456e9d96abd4364d2fd457c39"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d2863a3711b39dc8c010b1dd8888245a5969b3ac88b7649fd532f83da050ccd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fa791efd053cb237f8194a380d86325b69ed5a65fcc7ba442265f89bcb9c5ad"
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
    depends_on "icu4c@77"
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
