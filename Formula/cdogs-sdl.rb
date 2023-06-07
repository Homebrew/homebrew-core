class CdogsSdl < Formula
  desc "Classic overhead run-and-gun game"
  homepage "https://cxong.github.io/cdogs-sdl/"
  url "https://github.com/cxong/cdogs-sdl/archive/1.4.2.tar.gz"
  sha256 "9afc65dfb3e2672495b178ccc647f07656539e3c3787f852926a3ea8e2ca830f"
  license "GPL-2.0-or-later"
  head "https://github.com/cxong/cdogs-sdl.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_ventura:  "2708281d2eac7cb2b2333e1a3fc02d1fd13573b8177cc1fbcac362186c588eb2"
    sha256 arm64_monterey: "222bfa95e6b2dda8e5a8111557265f05597d2736a7bc66ffcad46ad2bb3b1334"
    sha256 arm64_big_sur:  "96703b0d082711f1ad60a1d79ba302483102ca6e9316509e07cbca652892f99c"
    sha256 ventura:        "d2179ec9ed7b9d8fb8bc744bb1f84d235c1612912573af4ce37c9458949bbe68"
    sha256 monterey:       "cd4c95d8db4732b8e8b28f190fc2e70bafb77ca4ce202726014037b925bb2fa2"
    sha256 big_sur:        "60a482e1eb34f2539f9466a8e689906fded8b881549b63bb0e422b3c7d507311"
    sha256 x86_64_linux:   "5ce57ecd621650a24be80d9a36bc3d40de32483e668a61d5a63ddf2af9c4c3ab"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "protobuf" => :build
  depends_on "python@3.11"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"

  on_linux do
    depends_on "glib"
    depends_on "gtk+3"
    depends_on "mesa"
  end

  def install
    args = std_cmake_args
    args << "-DCDOGS_DATA_DIR=#{pkgshare}/"
    system "cmake", ".", *args
    system "make"
    bin.install %w[src/cdogs-sdl src/cdogs-sdl-editor]
    pkgshare.install %w[data dogfights graphics missions music sounds]
    doc.install Dir["doc/*"]
  end

  test do
    pid = fork do
      exec bin/"cdogs-sdl"
    end
    sleep 7
    assert_predicate testpath/".config/cdogs-sdl",
                     :exist?, "User config directory should exist"
  ensure
    Process.kill("TERM", pid)
  end
end
