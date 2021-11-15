class Cdk < Formula
  desc "Curses development kit provides predefined curses widget for apps"
  homepage "https://invisible-island.net/cdk/"
  url "https://invisible-mirror.net/archives/cdk/cdk-5.0-20210825.tgz"
  sha256 "ce6e7785084d3480b77b96c94b26f6deb18e6ffb2f79bdccc7025ced70d800a4"
  license "BSD-4-Clause-UC"

  livecheck do
    url "https://invisible-mirror.net/archives/cdk/"
    regex(/href=.*?cdk[._-]v?(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1bbef2025a9c404b1c5eab2b741cfddc4fd6f40578ed213b70943d16e125941b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "344f6379a02727009b5385ee5bf119ed79c75fa68afa211993e0b5afa089565e"
    sha256 cellar: :any_skip_relocation, monterey:       "4874498202d4f4903e1d6a03caf11f09bdb5bcec561a3f2f797920127702da96"
    sha256 cellar: :any_skip_relocation, big_sur:        "6ace2dc8088541b3209fc03c6d43e6ab8307d4f8e8522fccb419afbef580c8d5"
    sha256 cellar: :any_skip_relocation, catalina:       "066170053968ce99cbd43655c517d54f11a041202f35b318b6489dc63a2cb4e6"
    sha256 cellar: :any_skip_relocation, mojave:         "24301e53626b28b778127ebb41f0b458ef74e50c3d5bb9ea716e76eb2874fbaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be4eeb2ff02dbc71efaa80e84ac8278ed120c550a68a1e162e76f9b0ace0b680"
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
