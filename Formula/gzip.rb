class Gzip < Formula
  desc "Popular GNU data compression program"
  homepage "https://www.gnu.org/software/gzip"
  url "https://ftp.gnu.org/gnu/gzip/gzip-1.11.tar.gz"
  mirror "https://ftpmirror.gnu.org/gzip/gzip-1.11.tar.gz"
  sha256 "3e8a0e0c45bad3009341dce17d71536c4c655d9313039021ce7554a26cd50ed9"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2d064cf47cc31ea7238c17f5305a5ddfb0e464e0ecd9591632a18264ddf3b98c"
    sha256 cellar: :any_skip_relocation, big_sur:       "c5193bef2b9a7974a169d32fd4e2191ea55b60aa31c3da5c4e2f8e132c0f71f7"
    sha256 cellar: :any_skip_relocation, catalina:      "903289308ce89ae70f3f8116738834d2c18fed8c248c1da82fde69cdca2b34a9"
    sha256 cellar: :any_skip_relocation, mojave:        "9391f27b1cf04c20abb2320ba55e1f8ac186db22b7c07bf51ebccfab073f85dd"
    sha256 cellar: :any_skip_relocation, high_sierra:   "d639fe5a95eb7c0e12aa1577ca9b230cdbbd31b0ef51794d57415f9a9fa68f08"
    sha256 cellar: :any_skip_relocation, sierra:        "bfd50566283402c72d15cd87670a3fd8ea122ebbaf583bc8cfafc552340ecf70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b3217b10402c6e826bdce453febfcf64e72389205a91d77eac3f2d8471df6cb"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"foo").write "test"
    system "#{bin}/gzip", "foo"
    system "#{bin}/gzip", "-t", "foo.gz"
    assert_equal "test", shell_output("#{bin}/gunzip -c foo")
  end
end
