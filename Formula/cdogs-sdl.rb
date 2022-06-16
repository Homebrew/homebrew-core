class CdogsSdl < Formula
  desc "Classic overhead run-and-gun game"
  homepage "https://cxong.github.io/cdogs-sdl/"
  url "https://github.com/cxong/cdogs-sdl/archive/1.3.1.tar.gz"
  sha256 "3b863a092b23da8b210383831ff490a10dd6fda77b997fe2bf39cedcfa0a8937"
  license "GPL-2.0-or-later"
  head "https://github.com/cxong/cdogs-sdl.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_monterey: "eb5081ddeb91e63f85aad85b8bfd43b1cd22f12db98707af53c7807dbcdb7e62"
    sha256 arm64_big_sur:  "7cd9e08437a8b784fc83ce9748cd35819bc592f2cdec326a9acaff99000b3b83"
    sha256 monterey:       "1e9a8a1dab42f9222aba255cfc97ca2d5c9b5b71591e831a49225b54237aaf53"
    sha256 big_sur:        "b29513a0cfa135dbe35a04de8bb6255612e099bd81db3c46c7c1029ea6785c32"
    sha256 catalina:       "269ea4482a28e0e3cf17aa42d709a852d192f630a74b34010e197ba236393877"
    sha256 x86_64_linux:   "bb6c48c390e2f57e54ea80086ac7673ebf0e63f819c25b8cf7cc6abfc9db2368"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "protobuf" => :build
  depends_on "python@3.10"
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
