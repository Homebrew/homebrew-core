class Ipbt < Formula
  desc "Program for recording a UNIX terminal session"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/ipbt/"
  url "https://www.chiark.greenend.org.uk/~sgtatham/ipbt/ipbt-20160908.4a07ab0.tar.gz"
  version "20160908"
  sha256 "7414ba38041c283db3b2c7bc119eecfcb193629c50f8509bd4693142813cea5d"

  bottle do
    cellar :any_skip_relocation
    sha256 "a9de6013e11b074ac7ecb8036e75b6954690add7213245bf3eaffd16182f9669" => :sierra
    sha256 "5d0a67f1c51c0e4f15b498f0877b491240b36207099a98d19ca7b0acf8313722" => :el_capitan
    sha256 "6b60f3a8177c298cec4bce8a53361fbea60e8f71be24b35504b2a699c2bd3f26" => :yosemite
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    system "#{bin}/ipbt"
  end
end
