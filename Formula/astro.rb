class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://github.com/astronomer/astro-cli/archive/refs/tags/v1.8.3.tar.gz"
  sha256 "b02eb16d1f0acecd04c1ca35f848403ef1d7c442386e0848fb35aeab9a744ae3"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3338b9b5b50efc61eca58a7262c3e20e30aa4e8afb86bf030d14d19cb5b20fe0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3338b9b5b50efc61eca58a7262c3e20e30aa4e8afb86bf030d14d19cb5b20fe0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3338b9b5b50efc61eca58a7262c3e20e30aa4e8afb86bf030d14d19cb5b20fe0"
    sha256 cellar: :any_skip_relocation, ventura:        "a905182b2bba2580dfd6839ea37b09cc3073bdb94524a8681caae45256f4e98d"
    sha256 cellar: :any_skip_relocation, monterey:       "a905182b2bba2580dfd6839ea37b09cc3073bdb94524a8681caae45256f4e98d"
    sha256 cellar: :any_skip_relocation, big_sur:        "a905182b2bba2580dfd6839ea37b09cc3073bdb94524a8681caae45256f4e98d"
    sha256 cellar: :any_skip_relocation, catalina:       "a905182b2bba2580dfd6839ea37b09cc3073bdb94524a8681caae45256f4e98d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f284de96a738182a1459fe737361c55afa8cbb8f7b31e89fe41518bc8cd4048e"
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
