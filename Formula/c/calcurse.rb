class Calcurse < Formula
  desc "Text-based personal organizer"
  homepage "https://calcurse.org/"
  url "https://calcurse.org/files/calcurse-4.8.2.tar.gz"
  sha256 "849ba852c7f37b6772365cb0c42a94cde0fe75efba91363e96a0e7ef797ba565"
  license "BSD-2-Clause"

  livecheck do
    url "https://calcurse.org/downloads/"
    regex(/href=.*?calcurse[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "36702d8f775d240b6968de8c9920deb70f8a1c4174efb8807a65b137a17abe6d"
    sha256 arm64_sequoia: "f120135e45863a612646065cb340a33af4dad61e43d7390ad13c04a1fb1cce97"
    sha256 arm64_sonoma:  "d242f4958c5af9df7208d7b933af6d7a37309754962b38b3979ac639edd28937"
    sha256 arm64_ventura: "3a330a186dc9bbd742e76b1b366f4a5c2e687ef7f7cee377e8f313cf61dd2d67"
    sha256 sonoma:        "fc2881f5a9216f5709a37c284406ee3e648c396fd90dedeadebcbee6bd3e8fde"
    sha256 ventura:       "0141f2a451f9d2be67f5f4e0baef21e97ae4821b4733cdc1c6af2e174ca0a0a1"
    sha256 arm64_linux:   "3c4da058a54e0a401ac9416c0a57e27e7fd05f02d1ab00bd0f8b4caef798d287"
    sha256 x86_64_linux:  "d3e722c7e8f3f64fec8f389fa7d46f5799d20a6bb1805a5b0b84aa491325f408"
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
