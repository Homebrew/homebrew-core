class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://github.com/openfga/openfga/archive/refs/tags/v1.5.3.tar.gz"
  sha256 "55d8674838f18c70714ef64a39e75db5516ec22b503bd4b8deb9d59198e835bd"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ae2d300ef2763309ba0833c68a9b4d425a1c30c2262fd5e90f33d6339d03adbc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "95bcb43446b47f389f4dee5cfad1e890dce08c77d2bb3ac635848e195889b792"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49d8d74816dbfa01714a2791958a09bb51b4745351063e89039ce45351fb508c"
    sha256 cellar: :any_skip_relocation, sonoma:         "8901af0aab2bd5f480523e85ac53cae98f1f7cfaadefe1c557e65d2738266359"
    sha256 cellar: :any_skip_relocation, ventura:        "4131c3607e9ad1b7fbef1f95cfcb5e0c20cb445a0b944298ca69f8e7233dd531"
    sha256 cellar: :any_skip_relocation, monterey:       "e5f5423616ba3a9bc8a34ae12683f2cf91780dc6c1ec47e98972367776601e49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16b07d6cdadf5e6101855966bcc936794775662b32f5d00f1bed6d9ef36baeb8"
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
