class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://github.com/astronomer/astro-cli/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "904be5c6f2a0d50fdec8b750b5cea81efb9a8b39efa38376427baa2f32008cc6"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f95ac5d8429e735c82a4616ac4d5a7f867a4772a2cad9537e2cd49ac99d2ef7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6f95ac5d8429e735c82a4616ac4d5a7f867a4772a2cad9537e2cd49ac99d2ef7"
    sha256 cellar: :any_skip_relocation, monterey:       "726fdb013ff4982061984028926b3a5bb4ce60f801a815c220e27019243db13a"
    sha256 cellar: :any_skip_relocation, big_sur:        "726fdb013ff4982061984028926b3a5bb4ce60f801a815c220e27019243db13a"
    sha256 cellar: :any_skip_relocation, catalina:       "726fdb013ff4982061984028926b3a5bb4ce60f801a815c220e27019243db13a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "adb57f7282ddb04a129db39530875d51f37467321b802845bfc3805b36312438"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/astronomer/astro-cli/version.CurrVersion=#{version}")

    generate_completions_from_executable(bin/"astro", "completion")
  end

  test do
    version_output = shell_output("#{bin}/astro version")
    assert_match("Astro CLI Version: #{version}", version_output)

    run_output = shell_output("echo 'y' | #{bin}/astro dev init")
    assert_match(/^Initializing Astro project*/, run_output)
    assert_predicate testpath/".astro/config.yaml", :exist?

    run_output = shell_output("echo 'test@invalid.io' | #{bin}/astro login astronomer.io", 1)
    assert_match(/^Welcome to the Astro CLI*/, run_output)
  end
end
