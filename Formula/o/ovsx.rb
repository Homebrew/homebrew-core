class Ovsx < Formula
  desc "Command-line interface for Eclipse Open VSX"
  homepage "https://www.npmjs.com/package/ovsx"
  url "https://registry.npmjs.org/ovsx/-/ovsx-0.10.10.tgz"
  sha256 "64458b3b5af09825afe832a8cf7481ac50cb5891e3f7e7d5e4e4b2888abcf89e"
  license "EPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b8033ba156e3c301b09ff3e3cbb41a0e03e65fab85ae05ca4749f9dc3d6446a7"
    sha256 cellar: :any,                 arm64_sequoia: "8fdda8f3858333dc8368b83e4060f540ad12d466788f1782f4d1bdeaac1a3b71"
    sha256 cellar: :any,                 arm64_sonoma:  "8fdda8f3858333dc8368b83e4060f540ad12d466788f1782f4d1bdeaac1a3b71"
    sha256 cellar: :any,                 sonoma:        "13862c478b67ffca985b854f21aa233e18f044e82bae1af25c421f058316b68e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6d2e14366f106ffe00d782adff60df98f4822e33dbe3a4a7285614279e6714b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e577d56fa8ad541ffbd23aadc3e633d93ab0d37cd62c23c3436bcf8b07f0a96f"
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
