class Nickle < Formula
  desc "Desk calculator language"
  homepage "https://www.nickle.org/"
  url "https://www.nickle.org/release/nickle-2.86.tar.gz"
  sha256 "2dca6c8e8d1fc4100d94b87d243053afd3340dbc6d284b5b2e48ce5ea159b17c"

  bottle do
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
