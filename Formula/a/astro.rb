class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://github.com/astronomer/astro-cli/archive/refs/tags/v1.38.1.tar.gz"
  sha256 "771aec85b9b3d4358bec42efb52e81043d6a848d126530d0324d4a5dbcb43407"
  license "Apache-2.0"
  head "https://github.com/astronomer/astro-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d74de9481e0f6ccd002ca88c55f1f9ed26c67eb444a80d014cc1acf00ea283d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10bc1f20edce4f53e53c26f5b0ef401110f884edd5f3ddda607d2e91ee3a3aff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8aab02740965250bcd99f4cf0beb9890697537c06cc7117bb0e732c2682ea4c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "12e0e6f31550aa46ace273871ad94a971806b2c5b78c65c13ab23c17350cab3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e14b56f6fe5175aec17f567f49c7c2fd20b45a6f2a908563be5a34996f4e6dd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa91ba67f2f132fcacb592745a92acddb1b40e390837ab4724c596658f02a607"
  end

  depends_on "go" => :build

  on_macos do
    depends_on "podman"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/astronomer/astro-cli/version.CurrVersion=#{version}")

    generate_completions_from_executable(bin/"astro", "completion")
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

    run_output = shell_output("echo 'test@invalid.io' | #{bin}/astro login astronomer.io --token-login=test", 1)
    assert_match(/^Welcome to the Astro CLI*/, run_output)
  end
end
