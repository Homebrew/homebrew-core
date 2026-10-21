class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-23.3.0.tgz"
  sha256 "462236d54b209ffcd61a39fbc777eeeaeda126328602936ea1f2cc38e78ad912"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "a4f07ced22e09d73a9381890881a806b6a173ddc15291dd4df5daf942245ed34"
    sha256 cellar: :any,                 arm64_tahoe:       "a4f07ced22e09d73a9381890881a806b6a173ddc15291dd4df5daf942245ed34"
    sha256 cellar: :any,                 arm64_sequoia:     "a4f07ced22e09d73a9381890881a806b6a173ddc15291dd4df5daf942245ed34"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3ef585c03f23a3b92688c71185bdf024a8eec2baf4f92fe8ac722d49ac44f2fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "4ddf233bc32ef1b6dc69a3b2da19ae5d9be7ebcc624ea83fd8fdce8df2b4ac02"
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
