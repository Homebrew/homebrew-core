class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://github.com/astronomer/astro-cli/archive/refs/tags/v1.41.0.tar.gz"
  sha256 "3db384e9a223d667543d5d9583cb916b0667256ad488c4027a7b214c8a59179f"
  license "Apache-2.0"
  head "https://github.com/astronomer/astro-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bbe69706cd3988b9713567a5b8b4a5f98085d6fadd0340c3536e1c0b466696ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cfed0738dd1adf7da615901c074080b5152fe1970def6c18a2c13dc30cacdfb9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2201fc6dcba0508aa96e1db14665c7db56ee3a3cb077f01d8602db5b2fec18d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc6c3e50fc44c4375d8b02b1ed3562ae52f12c2358a4baaac31d3aa1eb19485b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d3ccf9f9a8275ab19f662ece013b58090d791ab0b0eebc4222cebac3ee6eb7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0be64d5de33f36116f812e161fdebd9049409c85a8dfa8e7c26d4fd85d396c0"
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
