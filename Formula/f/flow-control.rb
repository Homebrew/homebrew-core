class FlowControl < Formula
  desc "Programmer's text editor"
  homepage "https://github.com/neurocyte/flow"
  url "https://github.com/neurocyte/flow.git", tag: "v0.3.2", revision: "7f99dc47332bf1d0912e0e51ee5b23450fddb918"
  license "MIT"
  head "https://github.com/neurocyte/flow.git", branch: "master"

  depends_on "zig" => :build

  # TODO
  # conflicts_with "flow-cli", because: "both install `flow` binaries"
  # conflicts_with "flow", because: "both install `flow` binaries"

  def install
    system "zig", "build", "-Doptimize=ReleaseSafe"
    bin.install "zig-out/bin/flow"
  end

  test do
    assert_match "Flow Control: a programmer's text editor", shell_output("#{bin}/flow --help")
    assert_match "version: v0.3.2", shell_output("#{bin}/flow --version")
  end
end
