class GnustepBase < Formula
  desc "Library of general-purpose, non-graphical Objective C objects"
  homepage "https://github.com/gnustep/libs-base"
  url "https://github.com/gnustep/libs-base/releases/download/base-1_30_0/gnustep-base-1.30.0.tar.gz"
  sha256 "00b5bc4179045b581f9f9dc3751b800c07a5d204682e3e0eddd8b5e5dee51faa"
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
    sha256 cellar: :any,                 arm64_sequoia: "ea43137e462651bed14654d6f3568cc8492737a08f5c46d8be3e20af283e69ac"
    sha256 cellar: :any,                 arm64_sonoma:  "ecf6464f4da0a825cc66b56634ca7c2cf002206e329ed1675744b69fa054ee85"
    sha256 cellar: :any,                 arm64_ventura: "1e74001b2ebbe64808248f9ea1fcf883f8214b94acb11034e1a588026d835c01"
    sha256 cellar: :any,                 sonoma:        "c656ea5e74ef316bdff831a8179ca085f5a8339f5b347ee9385fff91ebada811"
    sha256 cellar: :any,                 ventura:       "9afc177e4bb6eaea89c6920e9fc2574037596b5976034c0d861d9195ae9ac933"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6f9704b5d7ceae3cf1d3500f852493a7d9dc8dd37d75ee58566f8003907a4dd"
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
    depends_on "icu4c@76"
  end

  on_linux do
    depends_on "libobjc2"
    depends_on "zstd"
    fails_with :gcc
  end

  # fix incompatible pointer error, upstream pr ref, https://github.com/gnustep/libs-base/pull/414
  patch do
    url "https://github.com/gnustep/libs-base/commit/2b2dc3da7148fa6e01049aae89d3e456b5cc618f.patch?full_index=1"
    sha256 "680a1911a7a600eca09ec25b2f5df82814652af2c345d48a8e5ef23959636fe6"
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
