class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://github.com/astronomer/astro-cli/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "42d6bf6a7ce9285f2f9b70c66e6d4541f7eb8ff43aec330803f53ce1e0f0b17b"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b0c72eec1248a91ded82152af7f04df09f933bf087e7a51478ea23655450fafe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0c72eec1248a91ded82152af7f04df09f933bf087e7a51478ea23655450fafe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b0c72eec1248a91ded82152af7f04df09f933bf087e7a51478ea23655450fafe"
    sha256 cellar: :any_skip_relocation, ventura:        "0526ff64ce19725cd8d84b6f36d3ae51c3d5e198364bf7af80652bea591b2aa6"
    sha256 cellar: :any_skip_relocation, monterey:       "0526ff64ce19725cd8d84b6f36d3ae51c3d5e198364bf7af80652bea591b2aa6"
    sha256 cellar: :any_skip_relocation, big_sur:        "0526ff64ce19725cd8d84b6f36d3ae51c3d5e198364bf7af80652bea591b2aa6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89356d244fd6bab3e8f13683f0cda1004ed1a5dc636b915871fbe7cdd9be45ed"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/astronomer/astro-cli/version.CurrVersion=#{version}")

    generate_completions_from_executable(bin/"astro", "completion")
  end

  test do
    version_output = shell_output("#{bin}/astro version")
    assert_match("Astro CLI Version: #{version}", version_output)

    run_output = shell_output("echo 'y' | #{bin}/astro dev init")
    assert_match(/^Initializing Astro project*/, run_output)
    assert_predicate testpath/".astro/config.yaml", :exist?

    run_output = shell_output("echo 'test@invalid.io' | #{bin}/astro login astronomer.io --token-login=test", 1)
    assert_match(/^Welcome to the Astro CLI*/, run_output)
  end
end
