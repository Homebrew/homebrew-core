class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://github.com/astronomer/astro-cli/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "45e71932f1653996c37e58f6e69c83b77121ae337e1932e07979764fc9abc1f8"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f39eb2c24436444571706fb614b40084fd0e4ea076f178a01c37b7f45ca97fe3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f39eb2c24436444571706fb614b40084fd0e4ea076f178a01c37b7f45ca97fe3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f39eb2c24436444571706fb614b40084fd0e4ea076f178a01c37b7f45ca97fe3"
    sha256 cellar: :any_skip_relocation, ventura:        "e15e8dfd0db310e8dd819099310fba12ca1d5b8167a5e171f4e418a56ade357a"
    sha256 cellar: :any_skip_relocation, monterey:       "e15e8dfd0db310e8dd819099310fba12ca1d5b8167a5e171f4e418a56ade357a"
    sha256 cellar: :any_skip_relocation, big_sur:        "e15e8dfd0db310e8dd819099310fba12ca1d5b8167a5e171f4e418a56ade357a"
    sha256 cellar: :any_skip_relocation, catalina:       "e15e8dfd0db310e8dd819099310fba12ca1d5b8167a5e171f4e418a56ade357a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4cdc48f67c7593c1bdf1ce4fa62e4f3bc4f56fafbb1f5a24921a8523b6a2a83"
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
