class Crit < Formula
  desc "Your feedback loop with the agent: review plans and code locally"
  homepage "https://crit.md/"
  url "https://github.com/tomasz-tomczyk/crit/archive/refs/tags/v0.23.3.tar.gz"
  sha256 "34018ad7c49f52874beb355bd5b8f91bb997fc3697c59eb07b78ddbef077ef14"
  license "MIT"
  head "https://github.com/tomasz-tomczyk/crit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "34bce4cd91137ffe397dfe9565e4d5119859bec886bb375b3196795e5b49d59e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "34bce4cd91137ffe397dfe9565e4d5119859bec886bb375b3196795e5b49d59e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "34bce4cd91137ffe397dfe9565e4d5119859bec886bb375b3196795e5b49d59e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ba7f3595d9eb0a30296c676c7fb8fc0db2a4c94717bceace761e017521384371"
    sha256 cellar: :any,                 x86_64_linux:      "2921ec7c653ab2d4b29ab14b6a666f435ed152dc65a4262fcec6d293b44e9743"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X main.version=#{version}
      -X main.commit=brew
      -X main.date=#{time.iso8601[0, 10]}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/crit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/crit --version")

    (testpath/"hello.md").write("# Hello\n")
    system bin/"crit", "comment", "-o", testpath, "hello.md:1", "looks good"

    assert_path_exists testpath/"reviews"
  end
end
