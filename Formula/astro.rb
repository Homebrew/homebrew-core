class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://github.com/astronomer/astro-cli/archive/refs/tags/v1.13.2.tar.gz"
  sha256 "765ce4014f6ab519c04276eca62fa76208ec6f9cd0cf2a75788832b1ec841f96"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a06f25cfcaaf26dc06df41df615c2d67de2a157619b36cd876a95fc76ef2e443"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a06f25cfcaaf26dc06df41df615c2d67de2a157619b36cd876a95fc76ef2e443"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a06f25cfcaaf26dc06df41df615c2d67de2a157619b36cd876a95fc76ef2e443"
    sha256 cellar: :any_skip_relocation, ventura:        "f7b2fdb2e30b1fd928b08817b511777bdee494208d4f1d401d2fbf4cc7b56917"
    sha256 cellar: :any_skip_relocation, monterey:       "f7b2fdb2e30b1fd928b08817b511777bdee494208d4f1d401d2fbf4cc7b56917"
    sha256 cellar: :any_skip_relocation, big_sur:        "f7b2fdb2e30b1fd928b08817b511777bdee494208d4f1d401d2fbf4cc7b56917"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b3db5ceb2a17ac680a3cc0b37d0a06d2a3ab04d8e460bf073c03999c8487851"
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
