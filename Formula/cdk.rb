class Cdk < Formula
  desc "Curses development kit provides predefined curses widget for apps"
  homepage "https://invisible-island.net/cdk/"
  url "https://invisible-mirror.net/archives/cdk/cdk-5.0-20221025.tgz"
  sha256 "03ccfa21c9fc3d61ddd0fda19da545359055bbeef5a1c882dfb9ff48f3746af2"
  license "BSD-4-Clause-UC"

  livecheck do
    url "https://invisible-mirror.net/archives/cdk/"
    regex(/href=.*?cdk[._-]v?(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "de1edb7d3a05c9242b6b2ccc5760c16e5bcaccf32f687c2dc6ec7d7d9faacdaf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26e1fa427a24e0ebcd2a840a3446435ebbb2d084feb7b61202112aa547e10987"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a0f0d47e29420449fa15bea9e99714b356d55e74e3ac5ce07fbad070b234ec76"
    sha256 cellar: :any_skip_relocation, ventura:        "35aa8d67f3b0365d70de99f6eefac5793a473c2f29cf21c7f19497cef38250c3"
    sha256 cellar: :any_skip_relocation, monterey:       "79679684fc804b0a57a1dd82a7693af8bdff70d58d7ee72d88855db73eeb97b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "e06fdc82d641efcdbad6d5a179df2a3d7a8c5555cb330bc3558b13ca019e11fb"
    sha256 cellar: :any_skip_relocation, catalina:       "9b9d483ebf3fe05780a96d5eb5da83ca436644dd47d276ada4055fab52c5f692"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "119c821c5c64b841f6122616715edf1a845cd45ae732d34aad13fba1ffe652db"
  end

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}", "--with-ncurses"
    system "make", "install"
  end

  test do
    assert_match lib.to_s, shell_output("#{bin}/cdk5-config --libdir")
  end
end
