class Epinio < Formula
  desc "CLI for Epinio, the Application Development Engine for Kubernetes"
  homepage "https://epinio.io/"
  url "https://github.com/epinio/epinio/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "4ac5924deb7b10119bcd51edd37bd32e20d3885cc760f23dbfe1a928564c0e32"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e34b671d6301d05ed59d38672e748be8fdc5606acbea8e21e2487bd9c570576"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "02df7471a0e423f607c489d06595493a2a59ea81b45ddb855a17887d994cc3dd"
    sha256 cellar: :any_skip_relocation, monterey:       "32f41b5038391f6312368ead419bc92d60d916443605757827720213bfc484d2"
    sha256 cellar: :any_skip_relocation, big_sur:        "f006fe52d030c316938f5d43cf1bb4629bc33427218a8f52746b1344e05e7831"
    sha256 cellar: :any_skip_relocation, catalina:       "745d1aa7df4916ca2bc1682f56ac2966086f77dac58a7c54e084037113f8350f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31adbac291f81f07dbaab335f919fd74c1d980a74a95d018c75c325643db5671"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/epinio/epinio/internal/version.Version=#{version}")

    generate_completions_from_executable(bin/"epinio", "completion")
  end

  test do
    output = shell_output("#{bin}/epinio version 2>&1")
    assert_match "Epinio Version: #{version}", output

    output = shell_output("#{bin}/epinio settings update-ca 2>&1")
    assert_match "failed to get kube config", output
    assert_match "no configuration has been provided", output
  end
end
