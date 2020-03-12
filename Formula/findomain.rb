class Findomain < Formula
  desc "Cross-platform subdomain enumerator"
  homepage "https://github.com/Edu4rdSHL/findomain"
  url "https://github.com/Edu4rdSHL/findomain/archive/1.4.2.tar.gz"
  sha256 "01fc4e8adc6a61955c309cb8e8576048e35c45d6a9da002aa4589e06dc736029"

  bottle do
    cellar :any_skip_relocation
    sha256 "8d65b5ceb73da079cf8016cdeabee43105771912c0344ee0a556e2cc7e08d7c0" => :catalina
    sha256 "3e709719e6c444a58602f9dcc8a3dd00527108ba90f74beda04330aaa7aaba94" => :mojave
    sha256 "8faeacf51886ba54d6175809030de326b835d1deb2d3c256df31f3015ebfee97" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    assert_match "Good luck Hax0r", shell_output("#{bin}/findomain -t brew.sh")
  end
end
