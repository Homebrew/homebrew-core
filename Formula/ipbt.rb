class Ipbt < Formula
  desc "Program for recording a UNIX terminal session"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/ipbt/"
  url "https://www.chiark.greenend.org.uk/~sgtatham/ipbt/ipbt-20170831.3c40fd3.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/ipbt-20170831.tar.gz"
  version "20170831"
  sha256 "237394f7074a8e540495bdcb8b82b5a932f8597505e2ee3ba3d96b0671cfeae3"

  bottle do
    cellar :any_skip_relocation
    sha256 "cba6cc9d871841e1279a7560fd23d9781460c276c93382c32802fdad20ed51f3" => :sierra
    sha256 "4086610a0a5a0f531fe48ead28bd89b7457a1b46dfbf3f399c520c56358c5d1b" => :el_capitan
    sha256 "f1db5a7998dfdea0960c1eddc97d0534d735ffa92f367c2d1cd4e5f5cf2c6e2f" => :yosemite
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
