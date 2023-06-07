class AnycableGo < Formula
  desc "WebSocket server with action cable protocol"
  homepage "https://github.com/anycable/anycable-go"
  url "https://github.com/anycable/anycable-go/archive/v1.3.1.tar.gz"
  sha256 "d5155b991a813d7fee637189dad4ca0cba0b6a43fdc24a0418e56a368cdaca38"
  license "MIT"
  head "https://github.com/anycable/anycable-go.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70bd0d1c06bcd31b2daedbbb1b34f3ccb289e3007c5fc50569484babc8421f49"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a22548634b4c07e2369c18f14afc784827a9d40fa053da05be7ea1531240e51e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "70ab914b6266c3512ffd8c25c6d87ea43bc1bb0e9b381d0002bba376ff162db6"
    sha256 cellar: :any_skip_relocation, ventura:        "b7b1e1972b80ec041bfca939909780a4457a7d260b672afcb5793256f0d713b4"
    sha256 cellar: :any_skip_relocation, monterey:       "085b7ce7e77e774ee4b712ef0c9c277e4538a63acf421fc583dae12d9a1742fe"
    sha256 cellar: :any_skip_relocation, big_sur:        "2306cc89ee21d710096544a7a79ad728b07acec5e9f6eec156e8357d24525601"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff451de0c1281610764c754edee934485da5e34a537c3ff6476f839557fca96b"
  end

  depends_on "go" => :build

  def install
    ldflags = %w[
      -s -w
    ]
    ldflags << if build.head?
      "-X github.com/anycable/anycable-go/utils.sha=#{version.commit}"
    else
      "-X github.com/anycable/anycable-go/utils.version=#{version}"
    end

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/anycable-go"
  end

  test do
    port = free_port
    pid = fork do
      exec "#{bin}/anycable-go --port=#{port}"
    end
    sleep 1
    output = shell_output("curl -sI http://localhost:#{port}/health")
    assert_match(/200 OK/m, output)
  ensure
    Process.kill("HUP", pid)
  end
end
