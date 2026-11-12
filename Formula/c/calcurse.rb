class Calcurse < Formula
  desc "Text-based personal organizer"
  homepage "https://calcurse.org/"
  url "https://calcurse.org/files/calcurse-4.9.0.tar.gz"
  sha256 "8d4c36c868cc37d50decb49423548320488e64693d01527a272d1c2fb0afa8e6"
  license "BSD-2-Clause"

  livecheck do
    url "https://calcurse.org/downloads/"
    regex(/href=.*?calcurse[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "2eb8e08d63a8959d613c0d813d75a3df832c3954aae4af3af7514ec5c0f388b3"
    sha256 arm64_tahoe:       "ae659e6b960dd2c98f6079ac27fdaa69f035d1b0d1cc467d472b61115017cefa"
    sha256 arm64_sequoia:     "049e6b3779e9b7b032d939585c728fd085c37e93c1732b7d69f9bca7c1e4f37f"
    sha256 arm64_linux:       "7922ea58aeb354ce3bfeb0238349feb875810cdbd3f234ead28c396f566e3e2c"
    sha256 x86_64_linux:      "1b255f106d8b22fdbc11a70dadcc43cf9f9a9d4e944e8ecf27f26cd666205577"
  end

  head do
    url "https://git.calcurse.org/calcurse.git", branch: "master"

    depends_on "asciidoc" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkgconf" => :build
  uses_from_macos "ncurses"

  on_macos do
    depends_on "gettext"
  end

  deny_network_access!

  def install
    system "./autogen.sh" if build.head?

    system "./configure", *std_configure_args.reject { |s| s["--disable-debug"] }

    # Specify XML_CATALOG_FILES for asciidoc
    system "make", "XML_CATALOG_FILES=/usr/local/etc/xml/catalog"
    system "make", "install"
  end

  test do
    system bin/"calcurse", "-v"
  end
end
