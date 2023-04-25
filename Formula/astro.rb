class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://github.com/astronomer/astro-cli/archive/refs/tags/v1.14.1.tar.gz"
  sha256 "7e5080edb2e22b38138afd04fdb37145bdd2319c8b24354f3778dcf50a9c9e58"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "62d24f7f633f26170bed3ca965c507b14b3ccd023c4ff4d7d8aca429bbe47c24"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62d24f7f633f26170bed3ca965c507b14b3ccd023c4ff4d7d8aca429bbe47c24"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "62d24f7f633f26170bed3ca965c507b14b3ccd023c4ff4d7d8aca429bbe47c24"
    sha256 cellar: :any_skip_relocation, ventura:        "5412acce4846c776fd37dceeb8a17ad5060a9c699b92a896f3bf794fb4bd5818"
    sha256 cellar: :any_skip_relocation, monterey:       "5412acce4846c776fd37dceeb8a17ad5060a9c699b92a896f3bf794fb4bd5818"
    sha256 cellar: :any_skip_relocation, big_sur:        "5412acce4846c776fd37dceeb8a17ad5060a9c699b92a896f3bf794fb4bd5818"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa51ba27f521a85691805df8b52509ef883c7224b8b0fd301442aa69525c7e8c"
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
