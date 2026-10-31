class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-24.0.3.tgz"
  sha256 "7b28f6421f8547ebf1437655e903e25ac781e961e7068e40c3d0f6dcb76a0e1f"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "07e8f2b851eeb2ad3228dd394e31dae60daa985f1d2fc0a455934fe7e20eda98"
    sha256 cellar: :any,                 arm64_tahoe:       "07e8f2b851eeb2ad3228dd394e31dae60daa985f1d2fc0a455934fe7e20eda98"
    sha256 cellar: :any,                 arm64_sequoia:     "07e8f2b851eeb2ad3228dd394e31dae60daa985f1d2fc0a455934fe7e20eda98"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "68d540cd746514d13f75fd92f3d5795b4d1732220b4765a8c0845a7effb34407"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "cacaa32eb5550999916604ede4dfd134513ad23a6d08af350901726b7e437bb0"
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
