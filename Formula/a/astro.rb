class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://github.com/astronomer/astro-cli/archive/refs/tags/v1.40.1.tar.gz"
  sha256 "a2c736a944d451fe146aa68d2a3cb9a98fcab6b1a60947d8389c4cecdd18add9"
  license "Apache-2.0"
  head "https://github.com/astronomer/astro-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b8db8ac3c6051a40d9c0f49b80559fe4e786322ce77ddf6056aff6d04776d19"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "609ce7192493d37f1ac4618949342275ca7ce522e63563c4a57da6a361b5505d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "269268d26d86e5d302e0f37c1d2765d2a557a74b25a4938b6bf19cff7e7359c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "35db1aed6245c700f209609341a168be66b46fe62aa3149f530a1d1012b08495"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9aa45f5310ebb865c649e00258469fd09aaa1142667d5932f1778ae1d372430"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80ff107b4b4cd0f668e4c537d85e758a23f0f56597110361a3609aa6074268e3"
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
