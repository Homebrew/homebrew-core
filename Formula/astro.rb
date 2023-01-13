class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://github.com/astronomer/astro-cli/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "a32e52b85d19195639bd0fed05ca7ffebca4467513049a47af2504a746178738"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "819774e58df09821c59001d1505e9d6853ee10ce81fd2bbd1bdedea0567dd040"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "819774e58df09821c59001d1505e9d6853ee10ce81fd2bbd1bdedea0567dd040"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "819774e58df09821c59001d1505e9d6853ee10ce81fd2bbd1bdedea0567dd040"
    sha256 cellar: :any_skip_relocation, ventura:        "9c15edc0360d8959f79e3579b4205c3110afff3d1f1dbe39ca395f076afac77f"
    sha256 cellar: :any_skip_relocation, monterey:       "9c15edc0360d8959f79e3579b4205c3110afff3d1f1dbe39ca395f076afac77f"
    sha256 cellar: :any_skip_relocation, big_sur:        "9c15edc0360d8959f79e3579b4205c3110afff3d1f1dbe39ca395f076afac77f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba5da235638b779d46e21c2f8125fe5b1a844093b1dbf404e7280facb004bb68"
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
