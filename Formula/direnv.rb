class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/v2.11.2.tar.gz"
  sha256 "d2b0bb2bc2bfaa9308e8b5d96e377abc6f8cd41649eb98afb0489125a6f5239d"

  head "https://github.com/direnv/direnv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e1d212c1df209a6ead5acf61fc76bb63d35d46e788c2ac427044a0b53a9accb2" => :sierra
    sha256 "ab04e9a4a06b38ad0fa9d692aa33cd0c03e6a011ea6057503ce11911748f0fec" => :el_capitan
    sha256 "671ea289f3aaf970b376a980a527d1ee50ab0428e6c48a60534f88470c3b7c37" => :yosemite
  end

  depends_on "go" => :build

  def install
    system "make", "install", "DESTDIR=#{prefix}"
  end

  test do
    system bin/"direnv", "status"
  end
end
