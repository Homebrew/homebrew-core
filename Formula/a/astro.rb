class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://github.com/astronomer/astro-cli/archive/refs/tags/v1.26.0.tar.gz"
  sha256 "8a9b6fe71fdc59240d0e867bb0e780e746d36a939fbc0a54aa3a826e2039be55"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "73b8916139218d0ddbf9a8e767d2cae99efb9f2242f579b5d2af46dc1029fce9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "73b8916139218d0ddbf9a8e767d2cae99efb9f2242f579b5d2af46dc1029fce9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73b8916139218d0ddbf9a8e767d2cae99efb9f2242f579b5d2af46dc1029fce9"
    sha256 cellar: :any_skip_relocation, sonoma:         "af761baae4328a8413e011963629192b6b012a430a1c600f0796d04b83c55701"
    sha256 cellar: :any_skip_relocation, ventura:        "af761baae4328a8413e011963629192b6b012a430a1c600f0796d04b83c55701"
    sha256 cellar: :any_skip_relocation, monterey:       "af761baae4328a8413e011963629192b6b012a430a1c600f0796d04b83c55701"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "953e8bc61dca11de27ac717294b0ca3cbe8a72b387db25ae4d171671b476caed"
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
