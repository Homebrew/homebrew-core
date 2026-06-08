class Ovsx < Formula
  desc "Command-line interface for Eclipse Open VSX"
  homepage "https://www.npmjs.com/package/ovsx"
  url "https://registry.npmjs.org/ovsx/-/ovsx-1.0.0.tgz"
  sha256 "3e844c5ebfdc9ebbd1357a0f8ec78c80464cbe39f6bfe822f11179052afbf568"
  license "EPL-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "57c82aad9c4cbbe01b16250c9dd1ab05a8cf58e76b07afb1a2fd06da038df297"
    sha256 cellar: :any, arm64_sequoia: "9f12607f71576407d0e5d784df8130e6a62c9a906ffc0ce97fc76acbdcec3892"
    sha256 cellar: :any, arm64_sonoma:  "9f12607f71576407d0e5d784df8130e6a62c9a906ffc0ce97fc76acbdcec3892"
    sha256 cellar: :any, sonoma:        "2a5208feb4f14ac4966917d7e7be5b8bc9e516d34f95fc17ebf9a2a53a973f73"
    sha256 cellar: :any, arm64_linux:   "19ad0c9c51907d310e6a69e185b9474822236b978e390219e044734c37b354ea"
    sha256 cellar: :any, x86_64_linux:  "0a264b3c8d7324256b3f11764bf684c7423308b880e133ab76d64abbbda86b6a"
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
