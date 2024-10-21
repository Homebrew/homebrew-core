class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://github.com/astronomer/astro-cli/archive/refs/tags/v1.30.0.tar.gz"
  sha256 "5722e3ac3688990c8c780e24106275866a60b58d845386271d5f1f14a443205b"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4985c77cef0ff6ea8e28db972e60eaa9c5fd32de5ba64287da32e67d12fce10"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4985c77cef0ff6ea8e28db972e60eaa9c5fd32de5ba64287da32e67d12fce10"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a4985c77cef0ff6ea8e28db972e60eaa9c5fd32de5ba64287da32e67d12fce10"
    sha256 cellar: :any_skip_relocation, sonoma:        "387d60ed225e01a4b5efaf5d27627709ad9b6bf3ed25706160fc390958f5a219"
    sha256 cellar: :any_skip_relocation, ventura:       "387d60ed225e01a4b5efaf5d27627709ad9b6bf3ed25706160fc390958f5a219"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0a6ed9fbf5e668188dbae18eee36548bab3ea7d41e66815f0d51886cb7bf0c1"
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
