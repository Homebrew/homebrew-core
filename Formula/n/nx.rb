class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-24.0.4.tgz"
  sha256 "b5d729470659abdf10e36787ae46582eb998d965e5ff8ee5f661240edd538a3c"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "946b7d4d035e0f28d8c96deb32a0f114eb430dbebcf473c728cd357f05c494f1"
    sha256 cellar: :any,                 arm64_tahoe:       "946b7d4d035e0f28d8c96deb32a0f114eb430dbebcf473c728cd357f05c494f1"
    sha256 cellar: :any,                 arm64_sequoia:     "946b7d4d035e0f28d8c96deb32a0f114eb430dbebcf473c728cd357f05c494f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8ab08e9f1625b1aa2bf6f5df5b49fdae0dd1b55298ff24c35d6f9fccf27b663d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "cd8f44cb8dccf1f444fbc2c1157f932cadde654683b8f8e67193e73baf98c995"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    # Avoid daemon and plugin worker sockets in the test sandbox.
    ENV["NX_DAEMON"] = "false"
    ENV["NX_ISOLATE_PLUGINS"] = "false"

    (testpath/"package.json").write <<~JSON
      {
        "name": "@acme/repo",
        "version": "0.0.1",
        "scripts": {
          "test": "echo 'Tests passed'"
        }
      }
    JSON

    system bin/"nx", "init", "--no-interactive"
    assert_path_exists testpath/"nx.json"

    output = shell_output("#{bin}/nx test").gsub(/\e\[[0-9;]*m/, "")
    assert_match "Successfully ran target test for project @acme/repo", output
  end
end
