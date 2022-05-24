class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.40.0.tar.gz"
  sha256 "d5087651c0738b9925ecec0e545599b3b2cbf8c7e15791641b1dbc7fdeb23f6c"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a3a9cba5d436806eab97e55773250ba8bd04e5cef4ab523a4ea5e95f21ec80c7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "40f8773b3c75d66f5d5d0636ea982d00c16535260a712cbd211aaee5042694f1"
    sha256 cellar: :any_skip_relocation, monterey:       "e752b9f3e5d7626ca924ccb349bb9aea67ac015e2b7a51b01ee01f3b0e513186"
    sha256 cellar: :any_skip_relocation, big_sur:        "662694af2af9c5529273c75acfa6be144e24dc2a59a67ed4f51c01846cf0b742"
    sha256 cellar: :any_skip_relocation, catalina:       "66a3730a90b667781c72546e3f651057d22e703f401df4ebe1de479527c79988"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f63d006e822e4e7fb8940f4b168541d588b7edda29e423067f285e99a7c34cc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args,
              "-ldflags", "-X github.com/open-policy-agent/opa/version.Version=#{version}"
    system "./build/gen-man.sh", "man1"
    man.install "man1"

    bash_output = Utils.safe_popen_read(bin/"opa", "completion", "bash")
    (bash_completion/"opa").write bash_output

    zsh_output = Utils.safe_popen_read(bin/"opa", "completion", "zsh")
    (zsh_completion/"_opa").write zsh_output

    fish_output = Utils.safe_popen_read(bin/"opa", "completion", "fish")
    (fish_completion/"opa.fish").write fish_output
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "+---+---+\n| x | y |\n+---+---+\n| 1 | 2 |\n+---+---+\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end
