class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://github.com/astronomer/astro-cli/archive/refs/tags/v1.34.0.tar.gz"
  sha256 "da97c76d2ec1b97f2ae0851272620245e31897bc70d14ec1f52fc3cbf5e0f92d"
  license "Apache-2.0"
  head "https://github.com/astronomer/astro-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba1f098d190ca3120adfb44e32b782725b39997ff5929334124b7078def4622a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3fba3d7660cb36fb32c7ccb5f9dd2b9d4558fea82d0b5c6b250050c83a4d7409"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f9f39ec0089ec198e75e1bef7fe4210c4ddf11870758e969479cb21aa2d240da"
    sha256 cellar: :any_skip_relocation, sonoma:        "61b5b97b069faf325b55fca1a2d742bceff4930c2ab4c032151adfb042368e18"
    sha256 cellar: :any_skip_relocation, ventura:       "b6b8c4fe5d182a68f972a3f41ead1192abdc53d4de98860d8f2d4d33216deae9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77aed66b4fe51975220c383daaa9ec86ee99e6abda27b20721e67e8f747e4b09"
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
