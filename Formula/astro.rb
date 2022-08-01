class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://github.com/astronomer/astro-cli/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "349d1411950d323de0e5af166444c0abdab77ba22bf5c7a3749cc277ab4791d9"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74ec9fbecb9bbf6996b889ca7f89ef1b3bac2dd6e5d8245d34cef6a979608f90"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "74ec9fbecb9bbf6996b889ca7f89ef1b3bac2dd6e5d8245d34cef6a979608f90"
    sha256 cellar: :any_skip_relocation, monterey:       "300cae06021b8612c5dcac17a5d8be75c5bd05883f10e98a8bed113be9714d2f"
    sha256 cellar: :any_skip_relocation, big_sur:        "300cae06021b8612c5dcac17a5d8be75c5bd05883f10e98a8bed113be9714d2f"
    sha256 cellar: :any_skip_relocation, catalina:       "300cae06021b8612c5dcac17a5d8be75c5bd05883f10e98a8bed113be9714d2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d333e64d37ceb27c459ccfccc4fb3644a96d07e4b29c7114036e27b440750ac"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/astronomer/astro-cli/version.CurrVersion=#{version}")
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
