class Kamel < Formula
  desc "Apache Camel K CLI"
  homepage "https://camel.apache.org/"
  url "https://github.com/apache/camel-k/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "1e2864045f826fb8bf1f298f40b46e3ba6ff7462010165fef47c87a4df4699cf"
  license "Apache-2.0"
  head "https://github.com/apache/camel-k.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b5cdc5b87390b67c39ee00ba228cabe74569767a5f9abdc67d1cad6f0330d69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd808b03717da41c07bdf74749df777240cf428c772fb9a6420e6827cffc2722"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b22d2b6a1ee52a78fcebfdabc13684eef32ec4197a60b2e3d31daa7fae840154"
    sha256 cellar: :any_skip_relocation, sonoma:        "d66fea4cf9160c0af8996b0426c00012a126c2e619124c2d6dcd55ee8957a286"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39744c2e48c8dddc207eeaecf386814c53a9390dbd83450304db4c2d9d29c958"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04987ba2b75e6d5e0fc47c4c9e2d282173eacd1c0ebf0c492c241c3b64826b2b"
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
    assert_match "Error: cannot get command client: invalid configuration", rebuild_output

    reset_output = shell_output("echo $(#{bin}/kamel reset 2>&1)")
    assert_match "Error: cannot get command client: invalid configuration", reset_output
  end
end
