class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://github.com/astronomer/astro-cli/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "5121b7697f7db7a85b4e35af2410cb4832fa0fb3983217e3168f3cdbc2ef72b1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1fa2750156f778ab88619df1ef4e5b6ffe8dfaa8461c025ac1210ff909790f8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f1fa2750156f778ab88619df1ef4e5b6ffe8dfaa8461c025ac1210ff909790f8"
    sha256 cellar: :any_skip_relocation, monterey:       "30d1ce9a9eb4ade2fc5efd9c707592831b76083ae061d455d3691044383bfb9d"
    sha256 cellar: :any_skip_relocation, big_sur:        "30d1ce9a9eb4ade2fc5efd9c707592831b76083ae061d455d3691044383bfb9d"
    sha256 cellar: :any_skip_relocation, catalina:       "30d1ce9a9eb4ade2fc5efd9c707592831b76083ae061d455d3691044383bfb9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5816dca197a2b95bb4717d1cb08c03932534a5af5b305d2df407f29031438ca"
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
