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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52cf9f98b753a5d77c80154e580a1d15fff8c19b6d14ca4b1ba2d62941450b89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c6a6c6aec2dc84451f0b3ef6d8d008adf8a741d8214b8679e25cb9f22f91211"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a160813271c87340b72c5a935bfcc517b38c9e65a65d7871dd95db42242b55b"
    sha256 cellar: :any_skip_relocation, sonoma:        "390f668a975e78ca27b781740080a0ec5b5317cd3837c6d3d61f5640210c686f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9db86243eeb517eff3c92d86429abd14793acbb51654bcb8aa703a9514f3c297"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59e2d7ad73bbd7622cec1cf82d23a65e0dcd129d60cc4008772efd240ee5565f"
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
