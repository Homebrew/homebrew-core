class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://github.com/astronomer/astro-cli/archive/refs/tags/v1.27.1.tar.gz"
  sha256 "e50bda713cf89b8a1c7c1ee40b88e4b88ef834d5e62774c7bea247468a1134a0"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b6936c497cd8cce1c6308ffdfaedbf8a4a89f162e6ded9351583474d60aa5e74"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6936c497cd8cce1c6308ffdfaedbf8a4a89f162e6ded9351583474d60aa5e74"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6936c497cd8cce1c6308ffdfaedbf8a4a89f162e6ded9351583474d60aa5e74"
    sha256 cellar: :any_skip_relocation, sonoma:         "7ebac346366bb16d50d5b2303c97e2777828efd529430fd2341ebed8217ec134"
    sha256 cellar: :any_skip_relocation, ventura:        "7ebac346366bb16d50d5b2303c97e2777828efd529430fd2341ebed8217ec134"
    sha256 cellar: :any_skip_relocation, monterey:       "7ebac346366bb16d50d5b2303c97e2777828efd529430fd2341ebed8217ec134"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4545959a9ccd47c748fa35c82573c3bdff402f95fdde5e1a461b1e066e69bb2c"
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
