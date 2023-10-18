class Kamel < Formula
  desc "Apache Camel K CLI"
  homepage "https://camel.apache.org/"
  url "https://github.com/apache/camel-k/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "85c096a2ac43b5e5be52b4d2a455d9baf3b203da9d9e659e9a66bee3e9ca286a"
  license "Apache-2.0"
  head "https://github.com/apache/camel-k.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "266180947490923a38eb1878025640950b4ed5ab4c8318395eb9267fa63a8607"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e7b70f8309f5cc3093d8f3af8e1a48a542d80937f432b51287159b4bc33aef3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1960ccc6835a41888ee9ed4ffc9df10f86e62166f835ad80b662d3d718f7243c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "30b8b98dabc582240f126f616415bdf224cc1050bf99a95d32cabd30f4ba8949"
    sha256 cellar: :any_skip_relocation, sonoma:         "578811c259e3e80447170d48cf3fa29ee1e22cbb9770456650a7dacf452ea5d3"
    sha256 cellar: :any_skip_relocation, ventura:        "91da71ef4b480231875f520c58181bd0125e2dd1b2f609bedda60ed25ab29f07"
    sha256 cellar: :any_skip_relocation, monterey:       "48fcc8155bd7953fd45887d82af4a4fd7c68c39b17d5b9c4a74be4ce2f03fb6f"
    sha256 cellar: :any_skip_relocation, big_sur:        "423056e14ed91aa784ed97509681d7fe3ff08971d60169dcbd8bcfd4ad9aaf74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17e1325a82537bdfaedaa2a9e4731cadb4d8b7dbdd1941876db33633603bdf3c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/apache/camel-k/v2/pkg/util/defaults.GitCommit=#{tap.user}-#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/kamel"

    generate_completions_from_executable(bin/"kamel", "completion", shells: [:bash, :zsh])
  end

  test do
    run_output = shell_output("#{bin}/kamel 2>&1")
    assert_match "Apache Camel K is a lightweight", run_output

    help_output = shell_output("echo $(#{bin}/kamel help 2>&1)")
    assert_match "kamel [command] --help", help_output.chomp

    get_output = shell_output("echo $(#{bin}/kamel get 2>&1)")
    assert_match "Error: cannot get command client: invalid configuration", get_output

    version_output = shell_output("echo $(#{bin}/kamel version 2>&1)")
    assert_match version.to_s, version_output

    run_output = shell_output("echo $(#{bin}/kamel run 2>&1)")
    assert_match "Error: run expects at least 1 argument, received 0", run_output

    reset_output = shell_output("echo $(#{bin}/kamel reset 2>&1)")
    assert_match "Error: cannot get command client: invalid configuration", reset_output

    rebuild_output = shell_output("echo $(#{bin}/kamel rebuild 2>&1)")
    assert_match "Config not found", rebuild_output

    reset_output = shell_output("echo $(#{bin}/kamel reset 2>&1)")
    assert_match "Config not found", reset_output
  end
end
