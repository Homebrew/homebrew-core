class Kamel < Formula
  desc "Apache Camel K CLI"
  homepage "https://camel.apache.org/"
  url "https://github.com/apache/camel-k/archive/refs/tags/v2.3.2.tar.gz"
  sha256 "6bab60a6e7ae91f291bc575e5bfbbe4b9caf18f1a99ab0785f383c5b190534b5"
  license "Apache-2.0"
  head "https://github.com/apache/camel-k.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2ffa8a6e1a7ea3203e7622029965650afc5a9b8973f11b496378bf4a0841a3da"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6da5e49ff8d503b77bffc08983ca16a19e04c8dc82b8cbf8f97a818ce2a7d2a6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a3f7a4215d6117286fcbf1193606f50939c03602cc55ec50123867401a67ef6"
    sha256 cellar: :any_skip_relocation, sonoma:         "fc016809a7eba507cc282cd9cad6c3f211486ac76d878856cc54f27a4a88ae08"
    sha256 cellar: :any_skip_relocation, ventura:        "f7aa09bea5849d9b6363cb3a19c82226517dfe7bb6266fae011d2cf825f5df48"
    sha256 cellar: :any_skip_relocation, monterey:       "67c00217a6341f4947d666381d3ca516aac21860d5fd915a13dbc9e266687c40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6bcc7fe3c9927b78dd6f1f95143cbf7f246a5702feca736fe6dc6eb25eac17e0"
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
