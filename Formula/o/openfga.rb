class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://github.com/openfga/openfga/archive/refs/tags/v1.14.1.tar.gz"
  sha256 "cde380e188364e7daa8b83da997e31737500f8296865e1afe03f3a48b98b4b8a"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d9752866fd19502d95e2a22005e9420c4016df3ba27ccc073fde33fd1b5c88e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eeb2dd38ece815baf3fbb4e208f12fb67f445918d72c8f100a655137082eccb6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "574db7a2fd888f19f8adcc52c86cc1c0af751e1eda09fa5f651e5c8a4932e807"
    sha256 cellar: :any_skip_relocation, sonoma:        "e717cf58c06ffbc0ceff3ba1d7d7db457ad4eb8aae8f527b2437daf5ea0203fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "687bdc88a17032ef1fe321978b1ff3f6964ef82e15677ae68d2a01f570007524"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a88076893ae0550dc011d2a1632c651a02e30e39612e478b987a8cdb08b0cff"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/openfga/openfga/internal/build.Version=#{version}
      -X github.com/openfga/openfga/internal/build.Commit=#{tap.user}
      -X github.com/openfga/openfga/internal/build.Date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/openfga"

    generate_completions_from_executable(bin/"openfga", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openfga version 2>&1")

    port = free_port
    pid = spawn bin/"openfga", "run", "--playground-enabled", "--playground-port", port.to_s
    sleep 3
    output = shell_output("curl -s http://localhost:#{port}/playground")
    assert_match "title=\"Embedded Playground\"", output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
