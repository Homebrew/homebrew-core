class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://github.com/astronomer/astro-cli/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "67f0c5f8ee90f33d8f4d1139b4336d27df1cf66db3d237e07af157e45ee05888"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "806210e2153d851dda41b23ba44c78af85754fe3a7c522f3b299a2b8d593ab59"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "806210e2153d851dda41b23ba44c78af85754fe3a7c522f3b299a2b8d593ab59"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "806210e2153d851dda41b23ba44c78af85754fe3a7c522f3b299a2b8d593ab59"
    sha256 cellar: :any_skip_relocation, ventura:        "d087ef10dd7428a05aeb6e54260195efd735f51eb38225be1acb98f7437a4dbd"
    sha256 cellar: :any_skip_relocation, monterey:       "d087ef10dd7428a05aeb6e54260195efd735f51eb38225be1acb98f7437a4dbd"
    sha256 cellar: :any_skip_relocation, big_sur:        "d087ef10dd7428a05aeb6e54260195efd735f51eb38225be1acb98f7437a4dbd"
    sha256 cellar: :any_skip_relocation, catalina:       "d087ef10dd7428a05aeb6e54260195efd735f51eb38225be1acb98f7437a4dbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "333033bfb5f39cd6d72ab189b064e274f092ae3d7675bbd606605344c328a99f"
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
