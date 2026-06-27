class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://github.com/astronomer/astro-cli/archive/refs/tags/v1.43.0.tar.gz"
  sha256 "495cd23f5b704783247e79efb54ac0fcc5ee5cbedbd31e0a256a3f768b12b2bc"
  license "Apache-2.0"
  head "https://github.com/astronomer/astro-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a3a52ac9ff1e7185691e65aec26d1f6ef2bea88977f14b2c033b565281e6109d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d547dd2a701e3a2f74626d1eb5573aa1241d38ec8144b9fbd05df51a8c9cf82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e31e28f41e886175109e252e441b273690b2d9141a16d2350d5e1277985116e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "631193b9496441e62e8c67a18f50c5629c2df3014874f92a2528740e5fcabbb2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7eb8dc4f5f512ba8134d00ebaab722596140e5ba3a94602017ccb80c7424ac30"
    sha256 cellar: :any,                 x86_64_linux:  "b532fb48c16a80a64be47b2471a5726e6816e35276836981e87833cd432c0a75"
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
