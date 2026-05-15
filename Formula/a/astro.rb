class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://github.com/astronomer/astro-cli/archive/refs/tags/v1.42.0.tar.gz"
  sha256 "24fc78e50a761f46a94d4e0431e845e8e6da233c89625a0436098cc43cb8caa2"
  license "Apache-2.0"
  head "https://github.com/astronomer/astro-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "50e8528ab1fe11c39f7acbf3cfd5a47d24b6fb05e7001211b40d3a7d28758c8b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02da3d4c9b933e78955ef8275dc088d6bb52f92e54ce31f3d936275a3c2b39c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b937cdf1d642745ac298a07c48564fe15e7fe405cd79f8bcf2bd9dd6d214af5"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e128039f611185e1980b9d996ffbc29054312fafd7b90749a1cdc29ad5a8e7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31331aa59aba34b2acb7a5cd5ce08fc41730ecdbb498c6841249f6336585e85f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4e9fa7f6a23f2a309cfd79bc53eff12d556894960e73948547a8c01332c399c"
  end

  depends_on "go" => :build

  on_macos do
    depends_on "podman"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/astronomer/astro-cli/version.CurrVersion=#{version}")

    generate_completions_from_executable(bin/"astro", shell_parameter_format: :cobra)
  end

  test do
    version_output = shell_output("#{bin}/astro version")
    assert_match("Astro CLI Version: #{version}", version_output)

    mkdir testpath/"astro-project"
    cd testpath/"astro-project" do
      run_output = shell_output("#{bin}/astro config set -g container.binary podman")
      assert_match "Setting container.binary to podman successfully", run_output
      run_output = shell_output("#{bin}/astro dev init")
      assert_match "Initialized empty Astro project", run_output
      assert_path_exists testpath/".astro/config.yaml"
    end

    run_output = pipe_output("#{bin}/astro login astronomer.io --token-login=test", "test@invalid.io", 1)
    assert_match(/^Welcome to the Astro CLI*/, run_output)
  end
end
