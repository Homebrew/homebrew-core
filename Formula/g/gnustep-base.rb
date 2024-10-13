class GnustepBase < Formula
  desc "Library of general-purpose, non-graphical Objective C objects"
  homepage "https://github.com/gnustep/libs-base"
  url "https://github.com/gnustep/libs-base/releases/download/base-1_30_0/gnustep-base-1.30.0.tar.gz"
  sha256 "00b5bc4179045b581f9f9dc3751b800c07a5d204682e3e0eddd8b5e5dee51faa"
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
    sha256 cellar: :any,                 arm64_sequoia:  "8430a86df0234c7051da2d855d23d787d43d0c9ecdfad49c3fb317aa070bcc43"
    sha256 cellar: :any,                 arm64_sonoma:   "c147affcd59c6d9d1537d51569073c60905367407198c99bc6bd6baf38f21f08"
    sha256 cellar: :any,                 arm64_ventura:  "d673128135ac72b65c4ac7968125c90c890362d2eb7f95f85d343c00e3b4a370"
    sha256 cellar: :any,                 arm64_monterey: "a4302e0cbe7837a2b73ec760a82c3ccce8d2f999922570103f443e1346e78210"
    sha256 cellar: :any,                 sonoma:         "454142aa68dc511e98e55a83934874c5b5e7a8bdcaedd2ddd9c961ec67455e59"
    sha256 cellar: :any,                 ventura:        "1e0b3e5f607789b19eef999082ac660ab341c1d301c1bb7de4dd7b51c7b9e644"
    sha256 cellar: :any,                 monterey:       "73c8784c0168881336f054d764103ef3ade4400c749c15facf7560d5a59a2ae2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "703eade0a2484596b5dc6e4cee9b8b1b4d80c72d21de83a459d9189db28edc4a"
  end

  depends_on "gnustep-make" => :build
  depends_on "pkg-config" => :build
  depends_on "gmp"
  depends_on "gnutls"

  uses_from_macos "llvm" => :build
  uses_from_macos "icu4c", since: :monterey
  uses_from_macos "libffi"
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "zlib"

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

    if OS.mac? && (sdk = MacOS.sdk_path_if_needed)
      ENV["ICU_CFLAGS"] = "-I#{sdk}/usr/include"
      ENV["ICU_LIBS"] = "-L#{sdk}/usr/lib -licucore"

      # Fix compile with newer Clang
      ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403
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
