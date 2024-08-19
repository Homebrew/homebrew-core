class Ehco < Formula
  desc "Network relay tool and a typo :)"
  homepage "https://github.com/Ehco1996/ehco"
  url "https://github.com/Ehco1996/ehco/archive/refs/tags/v1.1.4.tar.gz"
  sha256 "7409064ad97040988826c86ae62a6230943f6ae1667571f39798e311e535fb79"
  license "GPL-3.0-only"
  head "https://github.com/Ehco1996/ehco.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "231df470a08a92dcf5e904ceda7c3f5b530cd88c3694517dc00f99cbf5249eb6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "39979432527f45f8cf6eddc335257d73f43b4ffae65d84cce6217496599b9241"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "faf1404fef3eebb3c1389e43df065fb520b5a13a0039f0f024597c488721737e"
    sha256 cellar: :any_skip_relocation, sonoma:         "4fd4b56fff548abc18353aad3589158d27984261141cf58933e3205c65c0a833"
    sha256 cellar: :any_skip_relocation, ventura:        "35b4e206605a39dd73c657cb7175abb63da2c3efa55a6f3394e034072dcc7115"
    sha256 cellar: :any_skip_relocation, monterey:       "288e20c323998e9748e09f3642b30d0347021bb15e33b6be421c57d829aafe96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb470e778aeeeb162968f48a891d7fedb1aae67df0f2e81ca2003dcfe8378062"
  end

  depends_on "go" => :build

  uses_from_macos "netcat" => :test

  def install
    ldflags = %W[
      -s -w
      -X github.com/Ehco1996/ehco/internal/constant.GitBranch=master
      -X github.com/Ehco1996/ehco/internal/constant.GitRevision=#{tap.user}
      -X github.com/Ehco1996/ehco/internal/constant.BuildTime=#{time.iso8601}
    ]

    # -tags added here are via upstream's Makefile/CI builds
    system "go", "build",
            "-tags", "nofibrechannel,nomountstats",
            *std_go_args(ldflags:), "cmd/ehco/main.go"
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
