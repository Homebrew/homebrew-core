class Kamel < Formula
  desc "Apache Camel K CLI"
  homepage "https://camel.apache.org/"
  url "https://github.com/apache/camel-k/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "f0d493352032c356836bd65851e8f801373e4c1564c1c4eb6430370669cc6a01"
  license "Apache-2.0"
  head "https://github.com/apache/camel-k.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7b4c3b59d1332e58d784e33d096e86386c1e3b69de42099a4577b1fbbe2ac58e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5da82cd554ca5c175e87d864ab20ea1119b8b53de76fc224d120c76d54264df3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9998d577ef425f2162e53db1130dd6013a31a540c5b45ad09f99b8556c95a424"
    sha256 cellar: :any_skip_relocation, sonoma:         "fb7986fe185f6dbbe677cd15d39e8d5ddae6834dd6d5280b534368ed46b6b17e"
    sha256 cellar: :any_skip_relocation, ventura:        "5ba08c28a2b015d41cd7f7d0968df012848d3e03c05d33e53a832d4c2481dcae"
    sha256 cellar: :any_skip_relocation, monterey:       "20210cf698afb923a9744f1f9914a9df71c74484154c42a50910b40b4844931a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "792b8906bc7b09dfe5a89bd2f6dc36037bf182526be61ee2a010cf36ceadfa5c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/apache/camel-k/v2/pkg/util/defaults.GitCommit=#{tap.user}-#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/kamel"

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

    reset_output = shell_output("echo $(#{bin}/kamel reset 2>&1)")
    assert_match "Error: cannot get command client: invalid configuration", reset_output

    rebuild_output = shell_output("echo $(#{bin}/kamel rebuild 2>&1)")
    assert_match "Config not found", rebuild_output

    reset_output = shell_output("echo $(#{bin}/kamel reset 2>&1)")
    assert_match "Config not found", reset_output
  end
end
