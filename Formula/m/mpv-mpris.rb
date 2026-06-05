class MpvMpris < Formula
  desc "MPRIS plugin for MPV"
  homepage "https://github.com/hoyon/mpv-mpris"
  url "https://github.com/hoyon/mpv-mpris/archive/refs/tags/1.2.tar.gz"
  sha256 "ecdc66f0182a38164b8bdc79502c575df3d2c4453bae5bff225c4e5ce9dbef6c"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "mpv"

  def install
    system "make"
    lib.install "mpv-mpris.so"
    pkgshare.install "README.md"
  end

  test do
    assert_path_exists lib/"mpv-mpris.so", :exist?
    assert_match "shared object", shell_output("file #{lib}/mpv-mpris.so")
  end
end
