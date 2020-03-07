class Dialog < Formula
  desc "Display user-friendly message boxes from shell scripts"
  homepage "https://invisible-island.net/dialog/"
  url "https://invisible-mirror.net/archives/dialog/dialog-1.3-20200228.tgz"
  sha256 "9ff8c41d1eee9e15d14fde3109d4612b1fe6dbe71fe2c3e743bcfff5e25c1fd9"

  bottle do
    cellar :any_skip_relocation
    sha256 "34cc03570f1ddcf3ef427954eae6a4a655e5823ca21307a85b5566c8bcad3f32" => :catalina
    sha256 "6c9ac92d375490253529b2f822175cf89fa94d5adaadcb65c1b2bc5ac3e93b05" => :mojave
    sha256 "4a530ceb592d84d48b427cc0721ddd9baab80edf7ba286f90e86d850f86749db" => :high_sierra
  end

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install-full"
  end

  test do
    system "#{bin}/dialog", "--version"
  end
end
