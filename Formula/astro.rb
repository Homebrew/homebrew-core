class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://github.com/astronomer/astro-cli/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "594c8edd0e22fc51a9f0961b00b3c7c15aeb0054b8774f55914440cff7e89d75"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5c2dc0d931436a7b65b437c4a2168af617c52414d179b9b1754501b56108b3e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b5c2dc0d931436a7b65b437c4a2168af617c52414d179b9b1754501b56108b3e"
    sha256 cellar: :any_skip_relocation, monterey:       "b9aacce854a9456cd71b12ea59ae21bf4497b282fe0d562a0b1beb45e8cf0549"
    sha256 cellar: :any_skip_relocation, big_sur:        "b9aacce854a9456cd71b12ea59ae21bf4497b282fe0d562a0b1beb45e8cf0549"
    sha256 cellar: :any_skip_relocation, catalina:       "b9aacce854a9456cd71b12ea59ae21bf4497b282fe0d562a0b1beb45e8cf0549"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15b1e016fb19e14ad147faf473ddbf12426289f5a4f846d18f567e6c80e54214"
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

    run_output = shell_output("echo 'test@invalid.io' | #{bin}/astro login astronomer.io", 1)
    assert_match(/^Welcome to the Astro CLI*/, run_output)
  end
end
