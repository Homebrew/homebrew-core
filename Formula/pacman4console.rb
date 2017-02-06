class Pacman4console < Formula
  desc "Pacman for console"
  homepage "https://sites.google.com/site/doctormike/pacman.html"
  url "https://sites.google.com/site/doctormike/pacman-1.3.tar.gz"
  sha256 "9a5c4a96395ce4a3b26a9896343a2cdf488182da1b96374a13bf5d811679eb90"

  bottle do
    sha256 "3a36192b5ad29f1795386c3fcb9b23418340ba89f2ba556ff3ad28535804db37" => :el_capitan
    sha256 "9789adc955f7a76c368e596bcf7744f14496d2529b4e63714e2c99bcbc8d5f20" => :yosemite
    sha256 "fd20126b10d66684bd40b181a1d243fdf4040accd3a84cca5678ba853bea6da8" => :mavericks
  end

  def install
    system "make", "prefix=#{prefix}", "datarootdir=#{pkgshare}"
    bin.install ["pacman", "pacmanedit"]
    (pkgshare+"pacman").install "Levels"
  end
end
