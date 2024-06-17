class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://github.com/openfga/openfga/archive/refs/tags/v1.5.4.tar.gz"
  sha256 "51782981296090b1df8245cb30be52fbcf6861b61d750943100af23f30018927"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ff3cc75246b25a9b9325923fa447f952e80b07efad69387ab155296596ef2552"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "66a11406732bb1383c244e89bef1085566155397b331d9f07a396614197fe11a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c94e33963c5faf53043464bed7f6d98ac24ff35ea7d8e1b08f36535c6b6469b7"
    sha256 cellar: :any_skip_relocation, sonoma:         "5f6d9dfb7dcee13b97e21830e6f4b3fb1700e9dc296f81383824ee192fbe52d5"
    sha256 cellar: :any_skip_relocation, ventura:        "5b1a8776cbc9063e9f7f46115428a2cf72a761de7dc8a4d6e2660692e43f5a7b"
    sha256 cellar: :any_skip_relocation, monterey:       "05f3dcd1c26a091b6dc1e8cdbd0ca5f92bf7a88e8db7788a46a21e05951304ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f81194d04d1069d58c6a29b2ec2fdafc586e77597fe10672dd2283b88f63798"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/openfga/openfga/internal/build.Version=#{version}
      -X github.com/openfga/openfga/internal/build.Commit=brew
      -X github.com/openfga/openfga/internal/build.Date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/openfga"

    generate_completions_from_executable(bin/"openfga", "completion")
  end

  test do
    port = free_port
    pid = fork do
      exec bin/"openfga", "run", "--playground-port", port.to_s
    end
    sleep 3
    output = shell_output("curl -s http://localhost:#{port}/playground")
    assert_match "title=\"Embedded Playground\"", output

    assert_match version.to_s, shell_output(bin/"openfga version 2>&1")
  ensure
    Process.kill("SIGTERM", pid)
    Process.wait(pid)
  end
end
