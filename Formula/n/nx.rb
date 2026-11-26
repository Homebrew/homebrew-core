class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-24.0.7.tgz"
  sha256 "23bd1e8139b85d0b5992a33e13bd422243f677a258c2b891704c4483436d67dc"
  license "MIT"
  version_scheme 1

  bottle do
    manifest_sha256 "bc3c6db907db8d465f3216d2a6c687b6c1c011b99f9ed6f807b6cdb082b4103c"
    sha256 cellar: :any,                 arm64_golden_gate: "ba82d113981c305f97b1be77a7b38528a33996399bb060820b80328ed61ebd5d"
    sha256 cellar: :any,                 arm64_tahoe:       "ba82d113981c305f97b1be77a7b38528a33996399bb060820b80328ed61ebd5d"
    sha256 cellar: :any,                 arm64_sequoia:     "ba82d113981c305f97b1be77a7b38528a33996399bb060820b80328ed61ebd5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "add07dd74c7f59c6d162cb2fd4e7522262602b584b014de3801c0c1fd33dc2e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "32e42c7925d63208101695a4e2c414c6a9e8d9277df95b6fea2a59059b3a19b2"
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
