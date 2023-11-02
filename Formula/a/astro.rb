class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://github.com/astronomer/astro-cli/archive/refs/tags/v1.19.4.tar.gz"
  sha256 "774400b17223df44e1ece56f24949efec3950debcfa2ba04ee4c168cf270ca9b"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1b078e6c64bdd152976414bff3b6e95875e68255c725f2d77c1b871ded011613"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b078e6c64bdd152976414bff3b6e95875e68255c725f2d77c1b871ded011613"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b078e6c64bdd152976414bff3b6e95875e68255c725f2d77c1b871ded011613"
    sha256 cellar: :any_skip_relocation, sonoma:         "88b623c7ae52688d019c3a412207f8abe1ba3c053e83c4a4bf5e90124fc57981"
    sha256 cellar: :any_skip_relocation, ventura:        "88b623c7ae52688d019c3a412207f8abe1ba3c053e83c4a4bf5e90124fc57981"
    sha256 cellar: :any_skip_relocation, monterey:       "88b623c7ae52688d019c3a412207f8abe1ba3c053e83c4a4bf5e90124fc57981"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7096ba8f40a5bc8672310167d10bce7df9ebb9e90dd543793b3eee12c689e68"
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
