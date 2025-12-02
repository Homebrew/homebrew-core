class Ehco < Formula
  desc "Network relay tool and a typo :)"
  homepage "https://github.com/Ehco1996/ehco"
  url "https://github.com/Ehco1996/ehco/archive/refs/tags/v1.1.5.tar.gz"
  sha256 "d6883b1ecdf4551f0b8fcbc8863089de0c5971944d0d2fa778835fd2ec76cfe8"
  license "GPL-3.0-only"
  head "https://github.com/Ehco1996/ehco.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "bebfba680eb1b47766b476e174b37f7e039b102005df3ade7724daaa3382191f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f18885bbcbafe2095ce0f0d3d7c180d8e2a646d69525a7528b38499ffa2ed065"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7a922799139ed0c48b58976708f27d3d59976c91f39db062720c3b502f70ec52"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ace45d76fd53671e7c3bbe1a75f7cf5b1e5c2098f5ba41c2a35ab10d71b050f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10ba3e478b23911fc098632347f408b9cfc4a38e2a46f86c6d6c7ee3582aa4d0"
    sha256 cellar: :any_skip_relocation, sonoma:         "321d48abbed4fd8b95819fe99bb469fd6003ffd8f1b2d5604cbbc61235edbf86"
    sha256 cellar: :any_skip_relocation, ventura:        "702dad8245708582ae80e98b18e421cfabf625446a7367c0f91f59ce9fb4ea40"
    sha256 cellar: :any_skip_relocation, monterey:       "4f6e8ee224725f9d7d5fe78ebf9db83950b878a8432856846c54cbd639510678"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "e5e7c812f56a609d3307077547bf17f03e60bd69fc0e04a9130794ad23720105"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6fc15a224177b50b7f245e3071f6d1116e77f4e9317424decedb3b38a4d346e6"
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
