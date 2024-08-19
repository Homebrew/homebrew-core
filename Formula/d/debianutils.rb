class Debianutils < Formula
  desc "Miscellaneous utilities specific to Debian"
  homepage "https://packages.debian.org/sid/debianutils"
  url "https://deb.debian.org/debian/pool/main/d/debianutils/debianutils_5.17.tar.xz"
  sha256 "367654878388f532cd8a897fe64766e2d57ae4c60da1d4d8f20dcdf2fb0cbde8"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://packages.qa.debian.org/d/debianutils.html"
    regex(/href=.*?debianutils[._-]v?(\d+(?:\.\d+)+).dsc/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8a78370632d98050927e832d1cfdb80ed64a690964445f1f88dc58a5e5628011"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "907fadee8644858dfc4271262edb7a68ee7a30e820d5ccf623d9234b08aa9521"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62356ab51a377150e2df6a9ec13cb254852b43e99cd7ecdfe24a5623b9bf91c9"
    sha256 cellar: :any_skip_relocation, sonoma:         "4ea1b528e74fce94809b36ee581a91a4e9a242195fe3be11c412fb0e59733eb3"
    sha256 cellar: :any_skip_relocation, ventura:        "3243ef275bc47e5e9b6897d04438e225b4d43e8ec9816ea6c8abbdf5384a0864"
    sha256 cellar: :any_skip_relocation, monterey:       "362d1a754b001b1b20660b859d8bf527fff2573e47a68eba7f7450cc3b002dea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9983d6defe478b019c2a76efa8f16b54e4e61aefe111d41d811f5414d6ab3cd5"
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
