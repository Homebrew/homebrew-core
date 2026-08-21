class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://github.com/astronomer/astro-cli/archive/refs/tags/v1.45.0.tar.gz"
  sha256 "d390f5a9aec106bba44a9dce1c0a27068682a6a7240c5573ceed5193e4625aaf"
  license "Apache-2.0"
  head "https://github.com/astronomer/astro-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "62e96d794bec8a890993b6d777fc3d559c991f4a87b43219bc9d0c6960d3be69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4d242faf0ba3887625815339c4465e1eaca61330e876fe155f8534d9aca1618"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1eaeb9caba33cc650223238eaab2ea24b735aea9d825114402e7665eaa1205ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "854eea480a48f56e271682f95a12c0a847904fdcdfa3b0ad9b53528b258cb26f"
    sha256 cellar: :any,                 x86_64_linux:  "171fc9c06c224f635e1bcc764e93b1b6e4ce988ef2ec9b4134ceb028640921e2"
  end

  depends_on "go" => :build

  on_macos do
    depends_on "podman"
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
