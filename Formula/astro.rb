class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://github.com/astronomer/astro-cli/archive/refs/tags/v1.15.1.tar.gz"
  sha256 "eb7707aaefab0eba2ee727c7c9adcc59c411409fb96d43ce378a6cb216dbf2f9"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "504baf0cb6b2bf1c3fa81e98a23dcd064f2b36d91cdb860648d89277c3b41d19"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "504baf0cb6b2bf1c3fa81e98a23dcd064f2b36d91cdb860648d89277c3b41d19"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "504baf0cb6b2bf1c3fa81e98a23dcd064f2b36d91cdb860648d89277c3b41d19"
    sha256 cellar: :any_skip_relocation, ventura:        "a35b0e8b87c3a941e3da0da8b77011916171997994079021a57591fdc2785b1e"
    sha256 cellar: :any_skip_relocation, monterey:       "a35b0e8b87c3a941e3da0da8b77011916171997994079021a57591fdc2785b1e"
    sha256 cellar: :any_skip_relocation, big_sur:        "a35b0e8b87c3a941e3da0da8b77011916171997994079021a57591fdc2785b1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b5184a98a5717802394bd727eddd5080b83e8d24f7e39e84e140fffba64e34d"
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
