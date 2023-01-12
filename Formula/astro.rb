class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://github.com/astronomer/astro-cli/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "a32e52b85d19195639bd0fed05ca7ffebca4467513049a47af2504a746178738"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7bb1931ab11b8264ea60f40c866b8368f0e8906e9d4b593e0fd6c4b0757f3a55"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7bb1931ab11b8264ea60f40c866b8368f0e8906e9d4b593e0fd6c4b0757f3a55"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7bb1931ab11b8264ea60f40c866b8368f0e8906e9d4b593e0fd6c4b0757f3a55"
    sha256 cellar: :any_skip_relocation, ventura:        "80b27c0cc1e0f5fe65dc15358eed1021bde2238776056be4f6e0fcff92c78084"
    sha256 cellar: :any_skip_relocation, monterey:       "80b27c0cc1e0f5fe65dc15358eed1021bde2238776056be4f6e0fcff92c78084"
    sha256 cellar: :any_skip_relocation, big_sur:        "80b27c0cc1e0f5fe65dc15358eed1021bde2238776056be4f6e0fcff92c78084"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb636f54744374f9130c568d5b304caed9e06128e79530a542e7429a45080d77"
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
