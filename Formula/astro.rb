class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://github.com/astronomer/astro-cli/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "04c213e998f237416e00bd5af30959bbea4aa1ed7729d791f1b608bb792b683d"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e985e920898363651e0796bdc180425f950c30f43b561b2f47fe97da21bb38ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b1f1749fadf0fc0199f9161d888e9385f42994e37dae8553e59ece80ae1c2a6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0b1f1749fadf0fc0199f9161d888e9385f42994e37dae8553e59ece80ae1c2a6"
    sha256 cellar: :any_skip_relocation, monterey:       "0e9670e916ca69abd65007652957b36b3cb5b1978fd1f50252339c29b33d86a2"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e9670e916ca69abd65007652957b36b3cb5b1978fd1f50252339c29b33d86a2"
    sha256 cellar: :any_skip_relocation, catalina:       "0e9670e916ca69abd65007652957b36b3cb5b1978fd1f50252339c29b33d86a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd0d597a3d81504372694b8e29fd0a773b53136790fd814bbb36602230c89504"
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
