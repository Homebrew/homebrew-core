class Ovsx < Formula
  desc "Command-line interface for Eclipse Open VSX"
  homepage "https://www.npmjs.com/package/ovsx"
  url "https://registry.npmjs.org/ovsx/-/ovsx-1.2.0.tgz"
  sha256 "c161a2730cd74021e087b7012e54070c438531abe51b2b2739390edefca9c59e"
  license "EPL-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "802beaafeb78d6968ac007e1585cb9d58ff9eeface919d113c6801cec2318cf5"
    sha256 cellar: :any, arm64_tahoe:       "802beaafeb78d6968ac007e1585cb9d58ff9eeface919d113c6801cec2318cf5"
    sha256 cellar: :any, arm64_sequoia:     "802beaafeb78d6968ac007e1585cb9d58ff9eeface919d113c6801cec2318cf5"
    sha256 cellar: :any, arm64_linux:       "8778b8ffebe41c399ad7493d9e1cc92b46c9ba2514836223a048227fa5956a03"
    sha256 cellar: :any, x86_64_linux:      "082da5214c2eb375084c21b31303fee3f34627f75785c790271bf8f7215184be"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    error = shell_output("#{bin}/ovsx verify-pat 2>&1", 1)
    assert_match "Unable to read the namespace's name", error
  end
end
