class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://github.com/astronomer/astro-cli/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "904be5c6f2a0d50fdec8b750b5cea81efb9a8b39efa38376427baa2f32008cc6"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9a2b2dddcb4b3a43b70e3c06f8ee78801ca86c8150ccd301b5d50eb015bcb7b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e9a2b2dddcb4b3a43b70e3c06f8ee78801ca86c8150ccd301b5d50eb015bcb7b"
    sha256 cellar: :any_skip_relocation, monterey:       "2706e06dbcf481b241fa914a2739405e9b09d62a98d4910f119890f530974c10"
    sha256 cellar: :any_skip_relocation, big_sur:        "2706e06dbcf481b241fa914a2739405e9b09d62a98d4910f119890f530974c10"
    sha256 cellar: :any_skip_relocation, catalina:       "2706e06dbcf481b241fa914a2739405e9b09d62a98d4910f119890f530974c10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cdebad63d007adee4a1f18551121275cee1a8bce81f68dd93667c5605f54e892"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/astronomer/astro-cli/version.CurrVersion=#{version}")
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
