class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://github.com/astronomer/astro-cli/archive/refs/tags/v1.32.1.tar.gz"
  sha256 "c29f470504d5048c0b9718968087ab4713a222f0f5e5c43759861dd29e77b728"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "656c89d2794b7cc89776df98227f810d855ec06143e04fa5a66db8d99e3add55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "656c89d2794b7cc89776df98227f810d855ec06143e04fa5a66db8d99e3add55"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "656c89d2794b7cc89776df98227f810d855ec06143e04fa5a66db8d99e3add55"
    sha256 cellar: :any_skip_relocation, sonoma:        "712b7b66b48b45b09c361261937564fabe355b8283126d90ae7455370a5bbd48"
    sha256 cellar: :any_skip_relocation, ventura:       "712b7b66b48b45b09c361261937564fabe355b8283126d90ae7455370a5bbd48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "500737cffc486c86250e7aedd50f398f6ec3bad39d7ab77216c2394126a6ee26"
  end

  depends_on "go" => :build
  on_macos do
    depends_on "podman"
  end

  def install
    ENV["CGO_ENABLED"] = "0"
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
