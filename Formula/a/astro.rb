class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://github.com/astronomer/astro-cli/archive/refs/tags/v1.18.2.tar.gz"
  sha256 "c322a984b5e993ca782e69994e32eb443cbb4ccb9d8173266e26e137f9ed739a"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "99b9e153d1bee752004c7d9227a0c5369481c2c1cd6932f97e8139245b5fcd83"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99b9e153d1bee752004c7d9227a0c5369481c2c1cd6932f97e8139245b5fcd83"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "99b9e153d1bee752004c7d9227a0c5369481c2c1cd6932f97e8139245b5fcd83"
    sha256 cellar: :any_skip_relocation, ventura:        "ccb116460096acf46de260666c6065ce74da7c5c00135784e8264517bc152779"
    sha256 cellar: :any_skip_relocation, monterey:       "ccb116460096acf46de260666c6065ce74da7c5c00135784e8264517bc152779"
    sha256 cellar: :any_skip_relocation, big_sur:        "ccb116460096acf46de260666c6065ce74da7c5c00135784e8264517bc152779"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a521ecf85356513b29b04a3cc21c5e8336a671fc2c2c312103f568803759f4b"
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
