class Nickle < Formula
  desc "Desk calculator language"
  homepage "https://www.nickle.org/"
  url "https://www.nickle.org/release/nickle-2.90.tar.gz"
  sha256 "fbb3811aa0ac4b31e1702ea643dd3a6a617b2516ad6f9cfab76ec2779618e5a4"

  livecheck do
    url "https://www.nickle.org/release/"
    regex(/href=.*?nickle[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "cf810e5b29755dc5d8cfabb31d609241acfa892a8ff5b8598451ce19fa6954d7" => :big_sur
    sha256 "d27c9f22a0526d8db09e27371181023ad120132f8a2ae63412b7d3b9e2564f0c" => :catalina
    sha256 "456ad0c96d0c02e44571cf8e24f4fbe9bc9a1a5296c896a0cfae05fea9e576d2" => :mojave
    sha256 "5887f0f5de76945279b8fe90c1be0dde47563b4ea5a97433611491c87e2487b3" => :high_sierra
  end

  depends_on "readline"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "4", shell_output("#{bin}/nickle -e '2+2'").chomp
  end
end
