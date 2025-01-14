class FlowEditor < Formula
  desc "Flow Control: a programmer's text editor"
  homepage "https://github.com/neurocyte/flow"
  url "https://github.com/neurocyte/flow/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "826097db34fe8ed012a0409872b1d46f9aa950949c551faf82a6c3f2b184532d"
  license "MIT"

  depends_on "zig"

  def install
    system "zig", "build", "-Doptimize=ReleaseSafe"
    bin.install "zig-out/bin/flow"
  end

  test do
    # Basic functionality test
    assert_match "Flow Control v0.2.1", shell_output("#{bin}/flow --version")
  end
end
