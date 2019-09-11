class Ipbt < Formula
  desc "Program for recording a UNIX terminal session"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/ipbt/"
  url "https://www.chiark.greenend.org.uk/~sgtatham/ipbt/ipbt-20180824.dc543d3.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/ipbt-20180824.tar.gz"
  version "20180824"
  sha256 "8347b373252a4c7054d476a39933287a146bb0e0f9dbfe86cd23931cf9eabb5c"

  bottle do
    cellar :any_skip_relocation
    sha256 "bd283b7c7c23687fe8d2805171c1abf50924e53d4072fe5bb3ca96e6fa16c206" => :mojave
    sha256 "8a353ed14fde241fdc9894083f36298f5374c06c264129b4f1468188633e2467" => :high_sierra
    sha256 "81dfccfb83c374d509ab37f7ad4cf8cc0d40bfb3b47e45d9d05ea3880e3d03aa" => :sierra
  end

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    system "#{bin}/ipbt"
  end
end
