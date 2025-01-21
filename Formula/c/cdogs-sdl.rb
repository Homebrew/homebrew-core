class CdogsSdl < Formula
  desc "Classic overhead run-and-gun game"
  homepage "https://cxong.github.io/cdogs-sdl/"
  url "https://github.com/cxong/cdogs-sdl/archive/refs/tags/2.2.0.tar.gz"
  sha256 "2730e331a60aadd584fe026d0167d9395947065da50b485fd32acd4788457f0b"
  license "GPL-2.0-or-later"
  head "https://github.com/cxong/cdogs-sdl.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "7819cab36b9f47e2a90b818e7eb475227a4dfc981bb5982055b419f36e1ecd3a"
    sha256 arm64_sonoma:  "ba340b0ffcf6de32eb25337153ac721cff45f260966024b7639c46812c1baa77"
    sha256 arm64_ventura: "893511a99c440fe030099e907e5d699760cfc2ed0c7d9cbfea2f1af934007633"
    sha256 sonoma:        "0e27435d8868c821eb5c3049a81ae08a63aef19c1ad88ed8af4ebf526cac0280"
    sha256 ventura:       "7b69e399d4c11141e90dab084be90c9baafbed74dceafce9ac60f1609267a6e1"
    sha256 x86_64_linux:  "894fc28e3abe311c9097a7c13fe4b70fd156d23e43ad977ec12ac7dc6f28c479"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
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
    system "cmake", "-S", ".", "-B", "build", "-DCDOGS_DATA_DIR=#{pkgshare}/", *std_cmake_args
    system "cmake", "--build", "build"

    bin.install %w[build/src/cdogs-sdl build/src/cdogs-sdl-editor]
    pkgshare.install %w[data dogfights graphics missions music sounds]
    doc.install Dir["doc/*"]
  end

  test do
    pid = spawn bin/"cdogs-sdl"

    max_sleep_time = 90
    time_slept = 0
    time_slept += sleep(5) while !(testpath/".config/cdogs-sdl").exist? && time_slept < max_sleep_time

    assert_path_exists testpath/".config/cdogs-sdl"
  ensure
    Process.kill("TERM", pid)
  end
end
