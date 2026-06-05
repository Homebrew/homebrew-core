class MpvMpris < Formula
  desc "MPRIS plugin for MPV media player"
  homepage "https://github.com/hoyon/mpv-mpris"
  url "https://github.com/hoyon/mpv-mpris/archive/refs/tags/1.2.tar.gz"
  sha256 "ecdc66f0182a38164b8bdc79502c575df3d2c4453bae5bff225c4e5ce9dbef6c"
  license "MIT"

  depends_on "mpv" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"

  livecheck do
    url :stable
    strategy :github_latest
  end

  def install
    system "make"
    lib.install "mpv-mpris.so"
    pkgshare.install "README.md"
  end

  test do
    assert_predicate lib/"mpv-mpris.so", :exist?
    assert_match "shared object", shell_output("file #{lib}/mpv-mpris.so")
  end
end
