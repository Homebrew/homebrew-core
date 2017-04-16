class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://github.com/hebcal/hebcal"
  url "https://github.com/hebcal/hebcal/archive/v4.13.tar.gz"
  sha256 "7b2e69b0e400ffd727fd818d926484c3f15a51cd6b325cea2483354501d6fce9"

  bottle do
    cellar :any_skip_relocation
    sha256 "4fad38cd59bf9544a0f620c7d67de93ce05a86356c995e370982fb0474af3288" => :sierra
    sha256 "cc18598a92f216fb3752258798c303844fc3ba9faf54fe77c4f58cff319c0ae9" => :el_capitan
    sha256 "591d6299c6dd53f60bb6435e8d3c225ba985659be6d581e2dfcd2a6cbfdab4d7" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./configure", "--prefix=#{prefix}", "ACLOCAL=aclocal", "AUTOMAKE=automake"
    system "make", "install"
  end

  test do
    system "#{bin}/hebcal"
  end
end
