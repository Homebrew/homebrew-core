class Dialog < Formula
  desc "Display user-friendly message boxes from shell scripts"
  homepage "https://invisible-island.net/dialog/"
  url "https://invisible-mirror.net/archives/dialog/dialog-1.3-20191210.tgz"
  sha256 "10f7c02ee5dea311e61b0d3e29eb6e18bcedd6fb6672411484c1a37729cbd7a6"

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
