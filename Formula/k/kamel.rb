class Kamel < Formula
  desc "Apache Camel K CLI"
  homepage "https://camel.apache.org/"
  url "https://github.com/apache/camel-k/archive/refs/tags/v2.3.3.tar.gz"
  sha256 "0a2ce0113407bb56b60ed38a0e150b0056eb890fc1daa5fc31695aef96233317"
  license "Apache-2.0"
  head "https://github.com/apache/camel-k.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b1f826cdca3ca00d6385b4db1e0bf3416baf7546d7cb987d34975683811149ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "390385ef425bee204736d84dd17479806c9e9019cc3f04c6feefb65695909a77"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "077970838a5d9cce6d125119d7702d06ade5e6eb87bb6eac44f0f46572b0e2c1"
    sha256 cellar: :any_skip_relocation, sonoma:         "0c9abae2584bf5f676145bb9b4ff5192264a36894bc27bc2620b15faa36cdbc2"
    sha256 cellar: :any_skip_relocation, ventura:        "c9f9d399a327009305f885c24feee4e51aaf943b79ca29d23d078872335ae873"
    sha256 cellar: :any_skip_relocation, monterey:       "8a74e9b0b530d3aee06c46a2082b47d4c9d937cfe3c9e8f40f54659df1fb153e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41e61377191ca1469ffc5eb789c3ff40e75ba828980d247798c03635e09df027"
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
