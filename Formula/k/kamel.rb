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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8db032d74ad88dd5e532628426912f70bf64f25cb65a4be90a70973c0826a946"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "71b43aa673ccc2418af447e009bbc5ae8af23d41a801143bf79009ead2757ca5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "591b6587e8230cbbc2913a7e303f38cb9645dba0975314336ee5de1fb165643f"
    sha256 cellar: :any_skip_relocation, sonoma:         "fc768db429b419b8d81e398891ed5bf0dfe3f8c4feb94bd65b247a1940674f2c"
    sha256 cellar: :any_skip_relocation, ventura:        "f4bc9e8e6899ad84316033b027e31c7e617b5ba837166b7e3f8c9221fed2d68f"
    sha256 cellar: :any_skip_relocation, monterey:       "6f9160b345785e20bcb06e5e01a84ca860e53ea018556363c9e77ca522690603"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85ab6fc744517fff686004a464041787aae14959a45ca691299c3d48f970f6a0"
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
    assert_match "Error: " \
                 "invalid configuration: " \
                 "no configuration has been provided, try setting KUBERNETES_MASTER environment variable", run_output

    reset_output = shell_output("echo $(#{bin}/kamel reset 2>&1)")
    assert_match "Error: cannot get command client: invalid configuration", reset_output

    rebuild_output = shell_output("echo $(#{bin}/kamel rebuild 2>&1)")
    assert_match "Config not found", rebuild_output

    reset_output = shell_output("echo $(#{bin}/kamel reset 2>&1)")
    assert_match "Config not found", reset_output
  end
end
