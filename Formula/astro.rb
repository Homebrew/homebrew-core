class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://github.com/astronomer/astro-cli/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "70cdb633ed705675ddb21290bdcf111353efc916d030ae2bbe54df013a05037e"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf336774c09477f4629a9a5d7eeae2fd1a388a079665e4fb63df340e73854701"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bf336774c09477f4629a9a5d7eeae2fd1a388a079665e4fb63df340e73854701"
    sha256 cellar: :any_skip_relocation, monterey:       "d28fb5b22b31bc7aa781626bd1c110a9a02fc9b96dd2db9f55ad727aa12961ed"
    sha256 cellar: :any_skip_relocation, big_sur:        "d28fb5b22b31bc7aa781626bd1c110a9a02fc9b96dd2db9f55ad727aa12961ed"
    sha256 cellar: :any_skip_relocation, catalina:       "d28fb5b22b31bc7aa781626bd1c110a9a02fc9b96dd2db9f55ad727aa12961ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef45ccb59be32ab080f673e6c1f62af871a5f20cfa15c96a216b0227efa41af9"
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
