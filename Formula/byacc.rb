class Byacc < Formula
  desc "(Arguably) the best yacc variant"
  homepage "https://invisible-island.net/byacc/"
  url "https://invisible-mirror.net/archives/byacc/byacc-20190617.tgz"
  sha256 "f87868167b920bf2cb30fc32b62f63ae15671181ef329226d1063100be02518d"

  bottle do
    cellar :any_skip_relocation
    sha256 "f5081b555e8e1c282cf5c3218cbaae6bbd69b5f8eef4108d4a6f04e04812f751" => :mojave
    sha256 "7f9c858f27a7dd7b42c8ba78829f86acd03378c35f48dbe76db1728a65ec3254" => :high_sierra
    sha256 "420f0b93cba45fc71a1d328787b660eca13b997976ec05d7c868cd1d413724f5" => :sierra
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--program-prefix=b", "--prefix=#{prefix}", "--man=#{man}"
    system "make", "install"
  end

  test do
    system bin/"byacc", "-V"
  end
end
