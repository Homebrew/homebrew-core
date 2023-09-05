class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://github.com/astronomer/astro-cli/archive/refs/tags/v1.19.1.tar.gz"
  sha256 "9bf6cf1ddb3000f5912b8cf3bc7f81d5e92defe0131da6a0a317e5ed8ecbe20b"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "078c6cfff40eff1dd48a9bffebe7d06ec0daf502e260d411858d46698a947214"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "078c6cfff40eff1dd48a9bffebe7d06ec0daf502e260d411858d46698a947214"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "078c6cfff40eff1dd48a9bffebe7d06ec0daf502e260d411858d46698a947214"
    sha256 cellar: :any_skip_relocation, ventura:        "865acbad1ec5f6c757a5d3354baef6fc5b607d8218aa66baeb6e3f31cf437c1e"
    sha256 cellar: :any_skip_relocation, monterey:       "865acbad1ec5f6c757a5d3354baef6fc5b607d8218aa66baeb6e3f31cf437c1e"
    sha256 cellar: :any_skip_relocation, big_sur:        "865acbad1ec5f6c757a5d3354baef6fc5b607d8218aa66baeb6e3f31cf437c1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03c061bba44ede396f5c10858e66a7218f3f253f22500b91d3573d3d080dd327"
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

    run_output = shell_output("echo 'test@invalid.io' | #{bin}/astro login astronomer.io --token-login=test", 1)
    assert_match(/^Welcome to the Astro CLI*/, run_output)
  end
end
