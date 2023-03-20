class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://github.com/astronomer/astro-cli/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "42d6bf6a7ce9285f2f9b70c66e6d4541f7eb8ff43aec330803f53ce1e0f0b17b"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e2f8f571972a8ab8f35d081756cb53a6737f44df020c1f2e2dd0348af06c9b03"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2f8f571972a8ab8f35d081756cb53a6737f44df020c1f2e2dd0348af06c9b03"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e2f8f571972a8ab8f35d081756cb53a6737f44df020c1f2e2dd0348af06c9b03"
    sha256 cellar: :any_skip_relocation, ventura:        "72fbfa56ef3e8d125e491703ef0407925f9c7e08af4e545014d00e6e56996e84"
    sha256 cellar: :any_skip_relocation, monterey:       "72fbfa56ef3e8d125e491703ef0407925f9c7e08af4e545014d00e6e56996e84"
    sha256 cellar: :any_skip_relocation, big_sur:        "72fbfa56ef3e8d125e491703ef0407925f9c7e08af4e545014d00e6e56996e84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b3cf0f057d61f43043af674faec30e898cce663e6cd7731bb1acc44d716a38d"
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
