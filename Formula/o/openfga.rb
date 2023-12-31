class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://github.com/openfga/openfga/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "38aa775c9e37f5c18c15e80185c677d998e0247fba74e0bb1b3b23e9849fb277"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f5f79c6358a87b1919bb5873f8f97133b815580f693e264adc6ff9ac79253082"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "176fbb01f60d2be2b91efd0c976987e75f9b133087be7a6268a880e42f16f623"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15e0d088075d74ee3dff8814df48a29cbdf0cc714356e6c7240c3452e4ec9d60"
    sha256 cellar: :any_skip_relocation, sonoma:         "a47066776311b382bea52c62c664f5d18ee90af1b6566d3af6b9cbb4136734f3"
    sha256 cellar: :any_skip_relocation, ventura:        "a322cba273af24468503d4b87fe7df0a7854f1ccd7ada40591188c9f822795bd"
    sha256 cellar: :any_skip_relocation, monterey:       "6c7fa152c995a0cf2e539cecc785959ccfeda34c183d763550418c86d101d0fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67185829b8181daa866b189feee558ba7cbbad095abaabba33dd7350c2338eea"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/openfga/openfga/internal/build.Version=#{version}
      -X github.com/openfga/openfga/internal/build.Commit=brew
      -X github.com/openfga/openfga/internal/build.Date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/openfga"

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
