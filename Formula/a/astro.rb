class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://github.com/astronomer/astro-cli/archive/refs/tags/v1.42.1.tar.gz"
  sha256 "e687666fb6a1f914228867b061c89820474e163057fde0ad4b4eb47f9650be76"
  license "Apache-2.0"
  head "https://github.com/astronomer/astro-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e27ff1dacf3f61822354d2eeb08d7b96a05ee7bb8349ad340f3630cd21e0dd0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb957ab8f8bbcd183ad2fd6d12d49c5bbf2efdf949afab36da2a7d07b9837a2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0fc09b32dc30262983b265e89a8d48a1076d25142b2836dfb082b2ee9db702b"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9ac5a78040fb2b942205bc419002b8b8e7d1d02392e70309e68042e09b0c022"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96afb409dd647d0b5d656b2ab3281908d586504bdde02ad62f1fc02db4eda893"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0eae6bed950be0f5a3fa99aa75908348b3057a15db6faf6529c3296a0f4429f"
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
