class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://github.com/astronomer/astro-cli/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "04c213e998f237416e00bd5af30959bbea4aa1ed7729d791f1b608bb792b683d"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd93f5ef69a8bb7bcc600d889c0cdc1ed2858cd7b5c8bd560b5b9640eb464bd3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd93f5ef69a8bb7bcc600d889c0cdc1ed2858cd7b5c8bd560b5b9640eb464bd3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bd93f5ef69a8bb7bcc600d889c0cdc1ed2858cd7b5c8bd560b5b9640eb464bd3"
    sha256 cellar: :any_skip_relocation, monterey:       "84dce0674115a43c07266641dad9a065e203bca71e4acdb56fdff14343efdcc2"
    sha256 cellar: :any_skip_relocation, big_sur:        "84dce0674115a43c07266641dad9a065e203bca71e4acdb56fdff14343efdcc2"
    sha256 cellar: :any_skip_relocation, catalina:       "84dce0674115a43c07266641dad9a065e203bca71e4acdb56fdff14343efdcc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10a62e4722e7087e4b024fc245eef8a98fd8b1b98f21f98d06f2b5d50cf2263d"
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
