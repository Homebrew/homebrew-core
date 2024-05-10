class Ehco < Formula
  desc "Network relay tool and a typo :)"
  homepage "https://github.com/Ehco1996/ehco"
  url "https://github.com/Ehco1996/ehco/archive/refs/tags/v1.1.3.tar.gz"
  sha256 "9d91dcc122578cf814574ed88d5c8517c74a2574e8af72d9d02f79376fcdb4bf"
  license "GPL-3.0-only"
  head "https://github.com/Ehco1996/ehco.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9decf4e78c060a0156bb071babb128f10bf1bd7add555a8bf6f06cc8b40b0d48"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a403caf4895fb1f5e645fc920edde5981dbcb731b66e4412e0bb3e52d824d1e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dac01d2b5b027c31038a355f25ee831977e4a8f8409772dfd81994e7952952d7"
    sha256 cellar: :any_skip_relocation, sonoma:         "001e18c6e8ae69e854d9755345d165fd0f8712781d7935644bb0dbbe5e334685"
    sha256 cellar: :any_skip_relocation, ventura:        "b621065178b625674903224b535d36e9565323b8d4dedd36efb587c4e59d93c8"
    sha256 cellar: :any_skip_relocation, monterey:       "83c8687ac92f19074e8d9ed41addea02c067b52f72d8a381fe27f375c21cf7d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "800a0d68efe206a9af19616db9376a4ef594821efc915619149f7703d4391e5b"
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

    system "go", "build", *std_go_args(ldflags:), "cmd/ehco/main.go"
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
