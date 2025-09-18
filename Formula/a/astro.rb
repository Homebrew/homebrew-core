class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://github.com/astronomer/astro-cli/archive/refs/tags/v1.36.0.tar.gz"
  sha256 "483df2b09bbb6c5e30eb46efe1cd0a8873c2fd5e71c7cdf8b931fdfe31039267"
  license "Apache-2.0"
  head "https://github.com/astronomer/astro-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f16bb51d03359fa56d24a982b6123b654c30e9f8f312f18cb32c06abe336f039"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d584655ef0d2b177221ad854c304ce32a3f11b6f9c458bc206db7dbb2a73c78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6acf4673f3b56fbc8426946e2c1ed32076cf97ce8895d0bdf3b64386a8f84d26"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "517197a9170e9e9e47ecfdae130bdf2dc293b13400161d7e2c0ab802cdd5e6f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "9eb7e98057ad496e3b5bb9d3f4a520621aa5879ae06e562bb9073596b1b66479"
    sha256 cellar: :any_skip_relocation, ventura:       "cef8677c3a2c7da4ca676bc93748c5590c1a17f279fd206d897cec6bfbc3709e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1163ba78ab454b0c502babf6fbc314366c45857fe121211db9cb0121fc361053"
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
