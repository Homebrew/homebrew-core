class Navidrome < Formula
  desc "Modern Music Server and Streamer compatible with Subsonic/Airsonic"
  homepage "https://www.navidrome.org"
  url "https://github.com/navidrome/navidrome/archive/refs/tags/v0.51.1.tar.gz"
  sha256 "fc962e3acbedfad63934eda016d4e380dd3a06b4636f2b1e61ade9700a2addcd"
  license "GPL-3.0-only"
  head "https://github.com/navidrome/navidrome.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a29670f39833b3ad8764a6e03ddc8640dd637d9cab1dde86340fada9e63fd343"
    sha256 cellar: :any,                 arm64_ventura:  "b9bd039e77a3c4a7ae3c2ef0f52c1469fd760ccf81d68a449a24217eafb76483"
    sha256 cellar: :any,                 arm64_monterey: "f4d91d6addfa0fd5fd3c884dc5879a8b2b4d8436faa07b8a7a5a2b4fa659348a"
    sha256 cellar: :any,                 sonoma:         "892aa537cac66baf54a9daa2a775ba7656b931490923037e0d0e1da6c5d06b75"
    sha256 cellar: :any,                 ventura:        "32314864d9e865c791bf82a6050131a111be97b61c06e3ddfb3b40d084c6562e"
    sha256 cellar: :any,                 monterey:       "72bc0a370b3f1e958ac20ee96ab1c4bd68edcb97bffdefd802792248484916e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32b2652863670e9e26bdc99196b02e2ce17a43396cde97ba68ef6c69c8148864"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "taglib"

  def install
    system "make", "setup"
    system "make", "buildjs"
    system "go", "build", *std_go_args(ldflags: "-X github.com/navidrome/navidrome/consts.gitTag=v#{version} -X github.com/navidrome/navidrome/consts.gitSha=source_archive"), "-buildvcs=false"
  end

  test do
    assert_equal "#{version} (source_archive)", shell_output("#{bin}/navidrome --version").chomp
    port = free_port
    pid = fork do
      exec bin/"navidrome", "--port", port.to_s
    end
    sleep 5
    assert_equal ".", shell_output("curl http://localhost:#{port}/ping")
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end
