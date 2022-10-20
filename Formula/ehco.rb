class Ehco < Formula
  desc "Network relay tool and a typo :)"
  homepage "https://github.com/Ehco1996/ehco"
  url "https://github.com/Ehco1996/ehco.git",
      tag:      "v1.1.1",
      revision: "c723fa0c3fefcc7f89c3847c6cd753cfdaf30486"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+){1,2})$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24d028b47e3f21743bb8e9ae6f02c60247806d7657e140ce4ba25c254e31f832"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "285974a17e80b0dc06803316d71f694ef0e0cef7449641e76738b18768b7f9a8"
    sha256 cellar: :any_skip_relocation, monterey:       "955b7bcfb6681ca0c733d02afcb50bf848d340c9f74b3ff01733160e585581e9"
    sha256 cellar: :any_skip_relocation, big_sur:        "c3081decea0e987e9115f3a0e67412372eb2fb7d6301992a62f3c3040bdd0bea"
    sha256 cellar: :any_skip_relocation, catalina:       "ca1802dc805cfe09c4ab7a06ab27592cf46c83eb708af4c399c35627af2a099b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b78ea30d2249f5c29e3642016edc43fde0e2ae4895cb6b7ae7ff80ef6e108a92"
  end

  depends_on "go" => :build

  uses_from_macos "netcat" => :test

  def install
    ldflags = %W[
      -s -w
      -X github.com/Ehco1996/ehco/internal/constant.GitBranch=master
      -X github.com/Ehco1996/ehco/internal/constant.GitRevision=#{Utils.git_short_head}
      -X github.com/Ehco1996/ehco/internal/constant.BuildTime=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "cmd/ehco/main.go"
  end

  test do
    version_info = shell_output("#{bin}/ehco -v 2>&1")
    assert_match "Version=#{version}", version_info

    # run nc server
    nc_port = free_port
    spawn "nc", "-l", nc_port.to_s
    sleep 1

    # run ehco server
    listen_port = free_port
    spawn bin/"ehco", "-l", "localhost:#{listen_port}", "-r", "localhost:#{nc_port}"
    sleep 1

    system "nc", "-z", "localhost", listen_port.to_s
  end
end
