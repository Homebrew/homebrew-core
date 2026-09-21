class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-23.2.1.tgz"
  sha256 "9da5b6ea573fb377221e13ede170c8a2576bd0819791193a09a55d52c8cfd28d"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "4acdadaa3fd1eaf9a3114dec39cf5ccf46670584ed70608f7e872c5b55f726a8"
    sha256 cellar: :any,                 arm64_tahoe:       "4acdadaa3fd1eaf9a3114dec39cf5ccf46670584ed70608f7e872c5b55f726a8"
    sha256 cellar: :any,                 arm64_sequoia:     "4acdadaa3fd1eaf9a3114dec39cf5ccf46670584ed70608f7e872c5b55f726a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fefeff6f9f5c15b8c2b36c0f4eea6a3fbaba9f0a707c224f2fd36ef9e3fb23d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "0dcc03262fa46dd356e04954e6e57e060258b9b5d3b755e5d0a2b8687a3176e2"
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
