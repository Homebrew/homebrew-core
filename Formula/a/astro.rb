class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://github.com/astronomer/astro-cli/archive/refs/tags/v1.19.3.tar.gz"
  sha256 "34cd3e6b5f142cebd25d8c4925027de826e30ba8f0f84a84fe9a12ff8e5fd77b"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0fdd5a071c4a98d33aee11d2f51b8da90c1ebfb9fcd9b9fe285bc4506dee6127"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0fdd5a071c4a98d33aee11d2f51b8da90c1ebfb9fcd9b9fe285bc4506dee6127"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0fdd5a071c4a98d33aee11d2f51b8da90c1ebfb9fcd9b9fe285bc4506dee6127"
    sha256 cellar: :any_skip_relocation, sonoma:         "1a2ac3aa98113cf1c3ba65d07658118d2ceff67bdfcbee5e3a688d9886ab1732"
    sha256 cellar: :any_skip_relocation, ventura:        "1a2ac3aa98113cf1c3ba65d07658118d2ceff67bdfcbee5e3a688d9886ab1732"
    sha256 cellar: :any_skip_relocation, monterey:       "1a2ac3aa98113cf1c3ba65d07658118d2ceff67bdfcbee5e3a688d9886ab1732"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b57c9c2a436b374689df16bde8914c68855fa6d7a9e85655ce98947a60e9a38e"
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
