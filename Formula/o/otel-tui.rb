class OtelTui < Formula
  desc "Terminal OpenTelemetry viewer"
  homepage "https://github.com/ymtdzzz/otel-tui"
  url "https://github.com/ymtdzzz/otel-tui/archive/refs/tags/v0.7.5.tar.gz"
  sha256 "fc8a5ab4416b9428532978cb759b31f83bc27e8617e44545c53fb41d401a3d91"
  license "Apache-2.0"
  head "https://github.com/ymtdzzz/otel-tui.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a75fd6e76633975acb72ae70c261a6f3820d97af8ce036a2012202df083baa7c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "46cd33dbfb6ced74ec32db3772c2ea1d0746a4a98bbc929e66d4ddeae25923f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8ebd7e9ee6757391872c066fe4f525f35f8a18e625a7c70f86461ba16247c2f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "cacf4ccb191213b466a0bdd7cef8aceb5812548d5a0bf9823bf3579c2aa3bd27"
    sha256 cellar: :any,                 x86_64_linux:      "dc3c25f7566e4ab82b7c6749e87880f316bb3b5ee8d495f1fb02ae47f692fb20"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
  end

  test do
    # otel-tui is a TUI application
    assert_match version.to_s, shell_output("#{bin}/otel-tui --version")
  end
end
