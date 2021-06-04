class Cdk < Formula
  desc "Curses development kit provides predefined curses widget for apps"
  homepage "https://invisible-island.net/cdk/"
  url "https://invisible-mirror.net/archives/cdk/cdk-5.0-20210324.tgz"
  sha256 "f62eb256bbcbca53ed549de03a3db257bd38e2965726b1cbeef7df2ed1aa781b"
  license "BSD-4-Clause-UC"

  livecheck do
    url "https://invisible-mirror.net/archives/cdk/"
    regex(/href=.*?cdk[._-]v?(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "418408498d8bac3d93334a17e443bf3e184d9d75f4f5004b5f061ae2414d7076"
    sha256 cellar: :any_skip_relocation, big_sur:       "ef4d022fd2b85806ca3f5d39974ebfec3a15840adc2ec8afac23fe3591d24626"
    sha256 cellar: :any_skip_relocation, catalina:      "da1e033bf75a24554fd51c1c255434d8b25759ec728f9371b9fe65651ef65db7"
    sha256 cellar: :any_skip_relocation, mojave:        "ae5301085365b01984a54f22ed421ed6c249afb2d7ba8426aed2d4c54111fbe5"
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
