class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-24.0.6.tgz"
  sha256 "2889e2c94ceb71aec7e39a0a2657a54feae55c1572867c200a8ba8540314023a"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "13211846052cf65d6eb8b3076826b0ba9bd2b6f8f44b79e65d80d828e5c3dc19"
    sha256 cellar: :any,                 arm64_tahoe:       "13211846052cf65d6eb8b3076826b0ba9bd2b6f8f44b79e65d80d828e5c3dc19"
    sha256 cellar: :any,                 arm64_sequoia:     "13211846052cf65d6eb8b3076826b0ba9bd2b6f8f44b79e65d80d828e5c3dc19"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e9584c281e5858e7a04c5a7b0ae1613f89018cc122cc73305fec41728749bdce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "91ab18061a6f83bf485427b4f2ba585645173d0974bbb461815f17cb708df6b7"
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
