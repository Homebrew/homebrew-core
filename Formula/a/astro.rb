class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://github.com/astronomer/astro-cli/archive/refs/tags/v1.48.0.tar.gz"
  sha256 "985c9db632670c5434b5d36fa7a907a3635fdc9fd1eb29e4e644bebc805ace01"
  license "Apache-2.0"
  head "https://github.com/astronomer/astro-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "3d5c449e9bc19be74c14556d5acf87fb44af358db8670b29882eb5b007468e17"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "eaf6e128efae2859a10be08ba19471f594c81bfe722d83801f1ac62ba59f8648"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "69145b7f13144594dcd9f138af794244ac07ff4fc24c39b33ac2957aa5e24691"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8e9bff377b91c2b33319e86761508b55b3628de2a759d5a362a7364e5d42e11b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "60162f827f8b5deaa92918b6d96aff0444813b77c5a621060ebbf2b7f1e96ceb"
    sha256 cellar: :any,                 x86_64_linux:      "e15954311b8b177a5e395e5f066f20159ef4f6edc662ce2f18a48352f4839d10"
  end

  depends_on "go" => :build

  on_macos do
    depends_on "podman"
  end

  # `test do` block queries updates.astronomer.io
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X github.com/astronomer/astro-cli/version.CurrVersion=#{version}")

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
