class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://github.com/astronomer/astro-cli/archive/refs/tags/v1.34.1.tar.gz"
  sha256 "33682819fe78164d34a52ee586a0ae9a0c0f41a387380c37e6fe8436dbf14d95"
  license "Apache-2.0"
  head "https://github.com/astronomer/astro-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4419ac3003d435b92bef3cb6b7da6abdaba68d87539fc3c1bf5bf02b8134964"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1548e1f78f42cd57e4ae79c5392150e929c62857800ce0b2d97e85883e0a4efb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "75900e43078430bb111f021b864e54746e93429145dbe49668ae34b8161c8075"
    sha256 cellar: :any_skip_relocation, sonoma:        "b67a2de203e92d0883e307bdf5c39682bbb9d48c93b1f5ff764ebc8294b54051"
    sha256 cellar: :any_skip_relocation, ventura:       "4c18599120798174f642fd1c5995d1584c6e3b5de60b750acc28120e19c6e440"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88887d54c8684bd4c5b79021e1e8013e8058eb4f4f70f9b31e7fbb9c1e5eef4e"
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
