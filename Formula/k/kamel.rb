class Kamel < Formula
  desc "Apache Camel K CLI"
  homepage "https://camel.apache.org/"
  url "https://github.com/apache/camel-k/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "74ae95ef3e21d0241ffd54024780b913aad08b10c41a2af94f017c38a5c68220"
  license "Apache-2.0"
  head "https://github.com/apache/camel-k.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea26b459df7510c41a7bd6ac1a4156db3bd65f8fe865892189d91e597bbb4090"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea26b459df7510c41a7bd6ac1a4156db3bd65f8fe865892189d91e597bbb4090"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ea26b459df7510c41a7bd6ac1a4156db3bd65f8fe865892189d91e597bbb4090"
    sha256 cellar: :any_skip_relocation, ventura:        "77f94e969a0a5b5a50df9cb468636f1fa37fc4e664b3d6f66d42f7378b2d2c03"
    sha256 cellar: :any_skip_relocation, monterey:       "77f94e969a0a5b5a50df9cb468636f1fa37fc4e664b3d6f66d42f7378b2d2c03"
    sha256 cellar: :any_skip_relocation, big_sur:        "77f94e969a0a5b5a50df9cb468636f1fa37fc4e664b3d6f66d42f7378b2d2c03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d06ff06c79216ea04423f85d9861e41904676e01ac75b5c642745ec1674038b"
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
