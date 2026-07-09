class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://github.com/openfga/openfga/archive/refs/tags/v1.18.1.tar.gz"
  sha256 "8e19a38a6422b323177cc2f9ecdb2fc9dd1827f17c785efbe6e513163c9854cb"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7b22040efa8bc81b5198c52cef8ec69da3958cfdd0667146eb485da9fa95e94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dcbfde34347ace1f501ffd312fe335fc7feb085870df2e0512c1c7253d08b9ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f03ec92f49d858e2f168fb496a519992a76f43f0e1b4b2640341c80a974cd31"
    sha256 cellar: :any_skip_relocation, sonoma:        "17d00e30c4260836a46123693c38fd5395dfd591afd2188cb2cf0d3da7ed471a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e34041b1ca877b7c1bb98404a7645d23e8694e268f69fe7ef287d386dbf86b0e"
    sha256 cellar: :any,                 x86_64_linux:  "728e6f310dadf9b08a586bc40758868eb30b8e798d295174b2dcd4282013b8d8"
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
