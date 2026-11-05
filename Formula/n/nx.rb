class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-24.0.4.tgz"
  sha256 "b5d729470659abdf10e36787ae46582eb998d965e5ff8ee5f661240edd538a3c"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "3cc8a9620394e2b3ce9679aa6116d63114963b4d4d4e9ef60d227fcf4bacee36"
    sha256 cellar: :any,                 arm64_tahoe:       "3cc8a9620394e2b3ce9679aa6116d63114963b4d4d4e9ef60d227fcf4bacee36"
    sha256 cellar: :any,                 arm64_sequoia:     "3cc8a9620394e2b3ce9679aa6116d63114963b4d4d4e9ef60d227fcf4bacee36"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4c96f60ae6028a2c3c2cd0541b26162b7fcd30966383954a2b3f49eaa7c3f6a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "4bccae174a3e23820a1047e0de5552d6be872d0c1fe207aa7ef9107e172b2480"
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
