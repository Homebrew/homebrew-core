class Ehco < Formula
  desc "Network relay tool and a typo :)"
  homepage "https://github.com/Ehco1996/ehco"
  url "https://github.com/Ehco1996/ehco/archive/refs/tags/v1.1.6.tar.gz"
  sha256 "002d18a6b631f5026b2dc90dbbe55dc46469fbaaef24ad812a281356d54ebe26"
  license "GPL-3.0-only"
  head "https://github.com/Ehco1996/ehco.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce103e44cecc91df6afb8fbc1de0832857851f393613b802cb966db8429851e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8bf2af4784fbb7d9d852ac928e11393068452d3dd6667340f3cd2e1155e224bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "214a9fd3b94ec63e70ab9b3866b42e41a4dc70b5d64eea8145910512b4446424"
    sha256 cellar: :any_skip_relocation, sonoma:        "60bedc9271b9192659103f62dcea107ff83244baff75d8b593b165e236b3dc4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eaf25741f4d61ba3f1b5ce1ba2fbffbbbf7c4ada95949d58549baf11b9a5d562"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d506b0b7b1914beb056d7d81c91704812e51d1673d490203f4c0802650cc58f2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Ehco1996/ehco/internal/constant.GitBranch=master
      -X github.com/Ehco1996/ehco/internal/constant.GitRevision=#{tap.user}
      -X github.com/Ehco1996/ehco/internal/constant.BuildTime=#{time.iso8601}
    ]
    # -tags added here are via upstream's Makefile/CI builds
    tags = "nofibrechannel,nomountstats"

    system "go", "build", *std_go_args(ldflags:, tags:), "cmd/ehco/main.go"
  end

  test do
    version_info = shell_output("#{bin}/ehco -v 2>&1")
    assert_match "Version=#{version}", version_info

    # run tcp server
    server_port = free_port
    server = TCPServer.new(server_port)
    server_pid = fork do
      session = server.accept
      session.puts "Hello world!"
      session.close
    end
    sleep 1

    # run ehco server
    listen_port = free_port
    ehco_pid = spawn bin/"ehco", "-l", "localhost:#{listen_port}", "-r", "localhost:#{server_port}"
    sleep 1

    TCPSocket.open("localhost", listen_port) do |sock|
      assert_match "Hello world!", sock.gets
    end
  ensure
    Process.kill "TERM", ehco_pid if ehco_pid
    Process.kill "TERM", server_pid if server_pid
  end
end
