class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://github.com/astronomer/astro-cli/archive/refs/tags/v1.19.2.tar.gz"
  sha256 "cb024d1e787102572964a8c3a391e9cffd152f8c0ec43da92ec45d6b15064863"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "033eba3ab4c048c7e9cc6b4de928cc44389d2d110b15e956c73f5203c212b9fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "033eba3ab4c048c7e9cc6b4de928cc44389d2d110b15e956c73f5203c212b9fb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "033eba3ab4c048c7e9cc6b4de928cc44389d2d110b15e956c73f5203c212b9fb"
    sha256 cellar: :any_skip_relocation, ventura:        "359bd3ebdd46cb2e1905616b0605c57019dba951c965892b1e0ebb805551bb0e"
    sha256 cellar: :any_skip_relocation, monterey:       "359bd3ebdd46cb2e1905616b0605c57019dba951c965892b1e0ebb805551bb0e"
    sha256 cellar: :any_skip_relocation, big_sur:        "359bd3ebdd46cb2e1905616b0605c57019dba951c965892b1e0ebb805551bb0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afd70318653b7d0df1b4fa2246b910095177d92db4bb60c1e57a3fd1a6c95b9c"
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
