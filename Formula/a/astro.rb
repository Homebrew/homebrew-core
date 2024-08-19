class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://github.com/astronomer/astro-cli/archive/refs/tags/v1.28.1.tar.gz"
  sha256 "fbbc7c3f4c7b03b916ca40350cee0395dc4d11ccf64fcd1f85295b17d5e7b03c"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c2b89c58317e983639515ccb0a83a22c8960f91b61eb446ba6d7f81a21c1aba6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c2b89c58317e983639515ccb0a83a22c8960f91b61eb446ba6d7f81a21c1aba6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2b89c58317e983639515ccb0a83a22c8960f91b61eb446ba6d7f81a21c1aba6"
    sha256 cellar: :any_skip_relocation, sonoma:         "f033ee5f46aed27f18ed3afa6285ecd6a4531154dc0cb61aec7d3ee2369628d5"
    sha256 cellar: :any_skip_relocation, ventura:        "f033ee5f46aed27f18ed3afa6285ecd6a4531154dc0cb61aec7d3ee2369628d5"
    sha256 cellar: :any_skip_relocation, monterey:       "4116b813552fa68d02e96f3e68824a3fa89bc0478872975279f346ae2bd6e122"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd37d72a05df49f3e1ad321e616e629c4796b41bdd22ab5b1fdf0fa024fbc25e"
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
