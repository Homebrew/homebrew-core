class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://github.com/openfga/openfga/archive/refs/tags/v1.4.3.tar.gz"
  sha256 "258f99c89107a17af19736063ee67b641aa30bc18a86b61122357f86ed945135"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8ed73abecfef689ed47b06371ccf841d9f88b849dc9b6a8243edecac25d61daf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a055a938e74c731cc83b54fc4146970c4dff58fbc952bb22428b8e6b00c96ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d412498f506184dda8fe02175754da0826497e29cd552f3a36d75e6a1fa31476"
    sha256 cellar: :any_skip_relocation, sonoma:         "ef41035471da44f5f6539d999f17a63af745679823cdfca3f26277cd1176f58c"
    sha256 cellar: :any_skip_relocation, ventura:        "93e45fca648316f4d7765f8210a0589c6ccaea2e7a61bc46ef08c725fe303064"
    sha256 cellar: :any_skip_relocation, monterey:       "ea59dadfdfc5c7a859c4b3ccf5cec42746b7c7219380ec01df5c01372ffc07c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e54eebc7bf38a51a603e155f877d9ff9e57d385b54434ec165c3b6022151bce"
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
