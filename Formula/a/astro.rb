class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://github.com/astronomer/astro-cli/archive/refs/tags/v1.33.2.tar.gz"
  sha256 "e65be029fd9de7b4d0c001620e431c209dfc9b49b410131de10f94d08eeae1c8"
  license "Apache-2.0"
  head "https://github.com/astronomer/astro-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e55e29fb8031c0bc3cf17b9a54a68a1ed6f5d875f881dee06fc1a8b7bb5ec918"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "815883babe5a38ccba8c411d32ce152b0b1dd303887302b4a55e38321e0dea32"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6161d75f1bb1154e68c8f1077f108f527ccaabc4526fefdf9d2f9ec0720e3f95"
    sha256 cellar: :any_skip_relocation, sonoma:        "316c5d95c007fa83f01193fb70349dfdc1af8ed38dc06d29e8679b4c2c945b6a"
    sha256 cellar: :any_skip_relocation, ventura:       "060f63a662c0b3600f1ef0a00eccf07ab0fa6fefd99e668050ef8859fc227890"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c9b9fae5dfe5b60f553d54ee4b9850f22c721bc4441123f49040ab4d764bdec"
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
