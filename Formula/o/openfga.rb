class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://github.com/openfga/openfga/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "0cf5fa105b7f255ba02e77b3ea8f507da31cf9f94a7d3c278718c60b8f9e0f40"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4ded6f50c42f73a351cf0c3d54f71d738bec4b7bca43340022bb042f395b0290"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c10629b6765fd9a404a2ca93dbd8911b473685aef0946670d63e37bdc6d6dd45"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0b54eae9f46ccd03cc951aa5fc0c4e4cd6592c317b7c2f92a0c24b1174a0236"
    sha256 cellar: :any_skip_relocation, sonoma:         "ffc0a6f937ea5086637eaee107dcf07fa782adace39599c8a43600fe86061f9d"
    sha256 cellar: :any_skip_relocation, ventura:        "72c6667cfae3e9b4fbe535dc941a99e10049ff2f29d61097a62cf97a337c1332"
    sha256 cellar: :any_skip_relocation, monterey:       "3f0e212dfc4b5d536ef854d3b9ea03acdd5c668789371814ddd63c9643aef4e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93028930f12c36c081a0b8b692addfd6bf7b76103a673b4755a872cc49cb0b63"
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
