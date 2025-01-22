class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://github.com/astronomer/astro-cli/archive/refs/tags/v1.33.0.tar.gz"
  sha256 "57f4e207c63ff45f06cac7597796452c3e8a26786aa6735e55a60007a1e42dd3"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2134df077c078b9e66b6f7bbb8b4683f5a88e470d1a076ed3fc08126ca07230b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b88afe208f91ab2892f8376ea5eb2de760ac9d344d0be2d3714590422b0cfa8f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ea581a0064bab7efc144f6342d0c0e2245ad7596d09bfd7319dbf0c4cc990f76"
    sha256 cellar: :any_skip_relocation, sonoma:        "da399443be3b70b7cb62e05cdaa2c2e59b479dd1d48ba8c1ec402572f0072cc5"
    sha256 cellar: :any_skip_relocation, ventura:       "153bfac081418956e42f8143d19e322477dec99f8f58ca9fd8c9c966bcc9ff0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "441ad7fed13afd54c6150f62edd0cb2f63552fc4a9f263fa838ca1a272449fe1"
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
      run_output = shell_output("#{bin}/astro dev init")
      assert_match "Initialized empty Astro project", run_output
      assert_path_exists testpath/".astro/config.yaml"
    end

    run_output = shell_output("echo 'test@invalid.io' | #{bin}/astro login astronomer.io --token-login=test", 1)
    assert_match(/^Welcome to the Astro CLI*/, run_output)
  end
end
