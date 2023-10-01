class Debianutils < Formula
  desc "Miscellaneous utilities specific to Debian"
  homepage "https://packages.debian.org/sid/debianutils"
  url "https://deb.debian.org/debian/pool/main/d/debianutils/debianutils_5.13.tar.xz"
  sha256 "74c30d41c7eb46fed5c7bb6a9b3c10de47ea777220bf51ebc700d99296bdb153"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://packages.qa.debian.org/d/debianutils.html"
    regex(/href=.*?debianutils[._-]v?(\d+(?:\.\d+)+).dsc/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df97d7ff05eb39718695a6e41e37ef4f772e842de39855a4a6f35e2b4986585d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa15bfad54a42448c00b23cea5c1c3d20af4fe40e51c7d783a99b9ab206563b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4e736217c519c0a5936b8688c6784157e27b1052b11d785247dab91752a2a3c4"
    sha256 cellar: :any_skip_relocation, ventura:        "75c6c80a9cf65298ed7a5eb432917ce3f48b71ef9f4637552aadd12b0aacbb3f"
    sha256 cellar: :any_skip_relocation, monterey:       "2708b24868d97c985bffaa6b1ec7ecaa25c812d28e3df76a8660a4a7fc358afc"
    sha256 cellar: :any_skip_relocation, big_sur:        "1043f16c427b7563d436b44e1b5662c2d8c6cf3732207c8c6f20399cb0006e04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f83933c2ae244d70371acfec86005649634af018845a5feb5b649017a0ffcb4d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build # for libintl
  depends_on "libtool" => :build
  depends_on "po4a" => :build

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"

    # Some commands are Debian Linux specific and we don't want them, so install specific tools
    bin.install "run-parts", "ischroot", "tempfile"
    man1.install "ischroot.1", "tempfile.1"
    man8.install "run-parts.8"
  end

  test do
    output = shell_output("#{bin}/tempfile -d #{Dir.pwd}").strip
    assert_predicate Pathname.new(output), :exist?
  end
end
