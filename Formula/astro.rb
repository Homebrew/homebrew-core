class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://github.com/astronomer/astro-cli/archive/refs/tags/v1.16.1.tar.gz"
  sha256 "653bac94842b11c10b8442808613eb080aee48a374460e428824af1d8ea24678"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a7629e2acade83be896144db1401387f7b88d844b36f3a5fc7e31d40311b553"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a7629e2acade83be896144db1401387f7b88d844b36f3a5fc7e31d40311b553"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a7629e2acade83be896144db1401387f7b88d844b36f3a5fc7e31d40311b553"
    sha256 cellar: :any_skip_relocation, ventura:        "f8c11700d498ae816054a20a497d4a184bb1b0a6432db8ac570d427c2ec2f2d6"
    sha256 cellar: :any_skip_relocation, monterey:       "f8c11700d498ae816054a20a497d4a184bb1b0a6432db8ac570d427c2ec2f2d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "f8c11700d498ae816054a20a497d4a184bb1b0a6432db8ac570d427c2ec2f2d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "903f0af974260366d098aff075364d79ac9b3755f216f449e53b29d19f419745"
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
