class Prips < Formula
  desc "Print the IP addresses in a given range"
  homepage "https://devel.ringlet.net/sysutils/prips/"
  url "https://devel.ringlet.net/files/sys/prips/prips-1.1.1.tar.xz"
  sha256 "16efeac69b8bd9d13c80ec365ea66bc3bb8326dc23975acdac03184ee8da63a8"

  bottle do
    cellar :any_skip_relocation
    sha256 "6dd9b01ce2a3e4267378068d0e48539d82637be1147064b1417f7bb70c4eed8b" => :mojave
    sha256 "5ce5225196dc7056ca5083f4b872ba0db72a1e2482f6410c8f6e20e92b838525" => :high_sierra
    sha256 "fc7f9aa1dcb04691722fe04f020c69da38eec97f4292269350a2934f624ac373" => :sierra
  end

  def install
    system "make"
    bin.install "prips"
    man1.install "prips.1"
  end

  test do
    assert_equal "127.0.0.0\n127.0.0.1",
      shell_output("#{bin}/prips 127.0.0.0/31").strip
  end
end
