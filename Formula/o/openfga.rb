class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://github.com/openfga/openfga/archive/refs/tags/v1.10.2.tar.gz"
  sha256 "db04f59c369f987d6cdcf71b3d4d05e22bff6458be53d7de2905167298305b3c"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "164cea839aa2b48dc80c95671cf0c469195f68688debbd7f2138ee09f44c6b11"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da1efec8407bf629c04d16154819810dd68ab88a0fc3a6fca97859594efe3ed3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "efb22e406fa91a35051bd7037049361ec73f9f1b00cd2fcacb9c01887bcc7fcb"
    sha256 cellar: :any_skip_relocation, sonoma:        "b71e90ff565a321cb60c008e26378f7d341d4f71ea23460794b5cd67384fcfa5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68580fdec1549e38133c056ae0e4480197db82d0266994631ee4ba478919805e"
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

    assert_match version.to_s, shell_output("#{bin}/openfga version 2>&1")
  ensure
    Process.kill("SIGTERM", pid)
    Process.wait(pid)
  end
end
