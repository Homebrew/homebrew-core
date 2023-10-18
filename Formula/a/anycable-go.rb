class AnycableGo < Formula
  desc "WebSocket server with action cable protocol"
  homepage "https://github.com/anycable/anycable-go"
  url "https://github.com/anycable/anycable-go/archive/v1.4.5.tar.gz"
  sha256 "28bedee45c76ef66c48d8131ff942a2f61058f00e6002c7cd6d515fec6b3fe59"
  license "MIT"
  head "https://github.com/anycable/anycable-go.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f40a950afdcc2722c7cf6f546f21251347a82c6597b3e8547b7d491a54e28b5a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff16e5bddbdc29e963c408faa58c42abba4d447a978eb66cdf4fa9e1f8f36ae9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69d61556badf4f72209b6e0d5de0fe9d2d993b31acf2dec07d645faae81da214"
    sha256 cellar: :any_skip_relocation, sonoma:         "113ab7682ad17ca3f7b6f2cb49457cfb158224d0b9d0c806ec707d807889e400"
    sha256 cellar: :any_skip_relocation, ventura:        "21498b20ff7765996eaf6699a2bbee79c20f72e29ad30f15e5197829bc2db50f"
    sha256 cellar: :any_skip_relocation, monterey:       "c033ab618c5266416f6084ff29bc3eac2808a69b08ef8bbe863cd13be0e7edf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34fe0ec0764864f9e9a11d9af674532715dbddd42a1c06a35795a93f61792ba0"
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
