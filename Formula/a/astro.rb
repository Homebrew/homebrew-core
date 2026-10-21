class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://github.com/astronomer/astro-cli/archive/refs/tags/v1.46.1.tar.gz"
  sha256 "0c37f6ebfee5bafab1384d13ff2e55351c4623b31b09476ec6730f51cfa189f2"
  license "Apache-2.0"
  head "https://github.com/astronomer/astro-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c4e9d907e28e3dc0e385d5eafc4cc78dcdceb2b6728677ac5da10cb58edac4fb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a89a8bcf10557e56062c6e59a20f2628fd916ca26e2a5ef0470242648917d590"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9db6670e056814fc241a0f9155778c0fb212a488bc1c8e6926b242f75e13f6df"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2ae8d0868c9291149482486deafc2ad198e5c06a7c8acff9fc8604012b1c917b"
    sha256 cellar: :any,                 x86_64_linux:      "6e723587584c12d7654afadd606d0a43947ffcaf3c39ba79faa7feb7dfbed2da"
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
