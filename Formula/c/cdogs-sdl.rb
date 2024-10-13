class CdogsSdl < Formula
  desc "Classic overhead run-and-gun game"
  homepage "https://cxong.github.io/cdogs-sdl/"
  url "https://github.com/cxong/cdogs-sdl/archive/refs/tags/2.1.0.tar.gz"
  sha256 "ea24c15cf3372f7d2fd4275cea4f1fd658a2bd5f79f7e6d0c8e3f98991c60dc2"
  license "GPL-2.0-or-later"
  head "https://github.com/cxong/cdogs-sdl.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "736dd36381bef76aa631f7696e22fc5b96cba0abcc99cfee9ae94fd8c3e796e5"
    sha256 arm64_sonoma:  "95b0f56706d78b2e473a116389305e73de5e9ded93aaee2619c33d304dd1535b"
    sha256 arm64_ventura: "41018296c2b1a57018fc3b5d3c24b3b9f4a152369ea5a25fcfa226705f65b867"
    sha256 sonoma:        "1da258a7f4c7e6cc4aa88d48d2f22f1cbb349c69c1c3cf4fd32a43959e58a7b0"
    sha256 ventura:       "df8f925f73f088fafac90515404af72c1686419114763b9fb7eb50d83cd62dea"
    sha256 x86_64_linux:  "e98f6240960c77881bd180e4e16bf546931d8b455ccf0c7e0531e9eb4395ec58"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "protobuf" => :build
  depends_on "python@3.13"
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
