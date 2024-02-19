class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://github.com/astronomer/astro-cli/archive/refs/tags/v1.23.0.tar.gz"
  sha256 "cbda1eeb5adac5d3be2188d56f2c82c7f68746a7eb3f62b1b079cdf6bf136968"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cb5b9038c98c3b4832f068f07356eebdd0b8619f19ef3a4c8725b82178edb100"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb5b9038c98c3b4832f068f07356eebdd0b8619f19ef3a4c8725b82178edb100"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb5b9038c98c3b4832f068f07356eebdd0b8619f19ef3a4c8725b82178edb100"
    sha256 cellar: :any_skip_relocation, sonoma:         "52a277b4d8a2c24b55800d90b086b28a45f3bad502cf8bff169bedf9af737729"
    sha256 cellar: :any_skip_relocation, ventura:        "52a277b4d8a2c24b55800d90b086b28a45f3bad502cf8bff169bedf9af737729"
    sha256 cellar: :any_skip_relocation, monterey:       "52a277b4d8a2c24b55800d90b086b28a45f3bad502cf8bff169bedf9af737729"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "375428aa2835f8c9e05604a4a8e4bddc9459db5f258d6a5b897e6463594ade61"
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
