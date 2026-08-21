class Gzip < Formula
  desc "Popular GNU data compression program"
  homepage "https://www.gnu.org/software/gzip/"
  url "https://ftpmirror.gnu.org/gnu/gzip/gzip-1.14.tar.gz"
  mirror "https://ftp.gnu.org/gnu/gzip/gzip-1.14.tar.gz"
  sha256 "613d6ea44f1248d7370c7ccdeee0dd0017a09e6c39de894b3c6f03f981191c6b"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0806e22497cecc96b52a14fbec21c29df976b5ae40f365a55508c23c2958222f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c82c69f648546f3d0e962e9012a2cb258b454b098ae880880dc88418dc544a41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "595f0a87dd1fe49c90e97911e72335a00cf096adbf84dfb17745dbf351ab9d3b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d55108d43ddf0f8123694f06882e223023cf4346f9b9640d6c33b657d19260bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "e590ecd558a1eec60fe790370d3ab2cde6d44fc918fe64ec98a56c31fbffc36c"
    sha256 cellar: :any_skip_relocation, ventura:       "39d86283bbdd91c6347ce5c7869e5a75db4d0bc6e961c8763fb7e81802cdeb55"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf3ee62bd32f32b5288069e02bd54a9b1df35b2ec45dfc1a403aa95c010e0f6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6cdbf878eda84da0ba1cac4bae09d3bf3c91ba1d5666806f9fa1ed19acc1f142"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"foo").write "test"
    system bin/"gzip", "foo"
    system bin/"gzip", "-t", "foo.gz"
    assert_equal "test", shell_output("#{bin}/gunzip -c foo")
  end
end
