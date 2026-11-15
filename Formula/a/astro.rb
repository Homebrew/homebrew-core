class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://github.com/astronomer/astro-cli/archive/refs/tags/v1.47.0.tar.gz"
  sha256 "d0b7363c415507c77aade69b070490b84c9e4df35f972f77714ddf8d733bb16d"
  license "Apache-2.0"
  head "https://github.com/astronomer/astro-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4577646bb520932f479b075a6b93f2627880067b92443c0de0c7cf1722553933"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "96bee68b28ff85e5642c3bc790513f0a2bc63432e684c58558b23b9a843046ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6ebfdaff81d8a69d518bfcef39c13a53be744076b7a0c621aa9de9ff91c60f23"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d9de4f9146c0532a1c87e20445309f3486c4e3b64ad42f1764bc53044f5ac29c"
    sha256 cellar: :any,                 x86_64_linux:      "b585563a1925769430cd83d230cff42dab1cabde3a91c7d05119aef588511d2a"
  end

  depends_on "go" => :build

  on_macos do
    depends_on "podman"
  end

  # `test do` block queries updates.astronomer.io
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X github.com/astronomer/astro-cli/version.CurrVersion=#{version}")

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
