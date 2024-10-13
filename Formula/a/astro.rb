class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://github.com/astronomer/astro-cli/archive/refs/tags/v1.29.0.tar.gz"
  sha256 "b9392eadc21d888b753e7c97c6f44da61ad0fcc90e9b2395e3fe39ee10cdcff5"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d11f3a3d4c1359738a0ac751f3021610ffbd0bd314ae62054f0b6f1a963dd8b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d11f3a3d4c1359738a0ac751f3021610ffbd0bd314ae62054f0b6f1a963dd8b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d11f3a3d4c1359738a0ac751f3021610ffbd0bd314ae62054f0b6f1a963dd8b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d11f3a3d4c1359738a0ac751f3021610ffbd0bd314ae62054f0b6f1a963dd8b6"
    sha256 cellar: :any_skip_relocation, sonoma:         "33c9e61022985d090f361a5e26b321f145cc545d30075cd96a4e8aa11c26897f"
    sha256 cellar: :any_skip_relocation, ventura:        "33c9e61022985d090f361a5e26b321f145cc545d30075cd96a4e8aa11c26897f"
    sha256 cellar: :any_skip_relocation, monterey:       "33c9e61022985d090f361a5e26b321f145cc545d30075cd96a4e8aa11c26897f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8d6093d24ff89ba4a7168502d96b74869486670e23dc0825aedd71ba8756fa0"
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
