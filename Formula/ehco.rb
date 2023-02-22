class Ehco < Formula
  desc "Network relay tool and a typo :)"
  homepage "https://github.com/Ehco1996/ehco"
  url "https://github.com/Ehco1996/ehco.git",
      tag:      "v1.1.2",
      revision: "3f649b356a33e317e4eaeeeca4590eedbd360892"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+){1,2})$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "adc2421757412baad839943b30e3bd213b52f1171771881b211926506174b1e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ecd00961cfe17e5062878d61d3fa2553a659c43a2e1712f355a6ff706f2ed38"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "10eb331567404c720188b82e8d8e0f11471af79ce6798370eac2d1d3ab47f59e"
    sha256 cellar: :any_skip_relocation, ventura:        "655e6f2667f39ddee1bd70c116782e98003bd5d5f19bb0c95f4b2efdced38833"
    sha256 cellar: :any_skip_relocation, monterey:       "e240c690c54ed6a593b6a56414c5b0c134336487ab5c4f10cd39ecf139e2eac1"
    sha256 cellar: :any_skip_relocation, big_sur:        "a82d6204833781c529f828e61833a5a62aaaa06bee39bc417f3749d7da429ac3"
    sha256 cellar: :any_skip_relocation, catalina:       "a34305a19622c8cf08f7992bc34e0b47202fb35a7187e7c90b50055613457252"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "566974576744f5056e4a7d4f5d3b14b0b6a4af3f25a8751f5fa5c1cf901c6e83"
  end

  depends_on "go@1.19" => :build

  uses_from_macos "netcat" => :test

  # Backport quic-go update to support Go 1.19
  # Remove in the next release
  patch do
    url "https://github.com/Ehco1996/ehco/commit/2f739a4279f9defaeb8beac9e97e82851e0dd995.patch?full_index=1"
    sha256 "43235566b344e0d125d79719800f1de61cd032f89892b183adf8220b1c5cd298"
  end

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
