class Kamel < Formula
  desc "Apache Camel K CLI"
  homepage "https://camel.apache.org/"
  url "https://github.com/apache/camel-k/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "6daf43eddcc495623c6d72873126d517c311bddb33b9760ff6a393746ac99645"
  license "Apache-2.0"
  head "https://github.com/apache/camel-k.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9d4aab56cc3091e565478d7690bb37bbd89379b72248b09729cfd6f0b50dc3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9d4aab56cc3091e565478d7690bb37bbd89379b72248b09729cfd6f0b50dc3e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e9d4aab56cc3091e565478d7690bb37bbd89379b72248b09729cfd6f0b50dc3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "12742f199c61f434187c4987b7e7d497457b4da53f8d0af923cc8f6a7dd61677"
    sha256 cellar: :any_skip_relocation, ventura:       "12742f199c61f434187c4987b7e7d497457b4da53f8d0af923cc8f6a7dd61677"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "600a8d5222d7278cf7e1f79ec0114204ed7244ea088c802c1a2ac37edebc2a20"
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
