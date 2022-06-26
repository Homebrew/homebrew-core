class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://github.com/astronomer/astro-cli/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "7d5faf13c69e5699a87c9ada2d39dd25aa2b5693b4f6d06a02d2e6430bea23a1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a3f7407131ce8b82fe8bfd53c9d422d01166cd38a35f37fb11fab0efb9a5cb82"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a3f7407131ce8b82fe8bfd53c9d422d01166cd38a35f37fb11fab0efb9a5cb82"
    sha256 cellar: :any_skip_relocation, monterey:       "0da2d1a5a69eb348f7c6a2d35290c0726e6091d72b32c4b2aeb135a037a30e85"
    sha256 cellar: :any_skip_relocation, big_sur:        "0da2d1a5a69eb348f7c6a2d35290c0726e6091d72b32c4b2aeb135a037a30e85"
    sha256 cellar: :any_skip_relocation, catalina:       "0da2d1a5a69eb348f7c6a2d35290c0726e6091d72b32c4b2aeb135a037a30e85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0fd2b1312ba4e8805689b81d96813e6cc70cba710f86ac3cea3bf39da31af10e"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/astronomer/astro-cli/version.CurrVersion=#{version}")
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
