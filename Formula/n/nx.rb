class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-24.0.5.tgz"
  sha256 "f20d66b0eb82c15fac089b60f700c93253ac856a2e98fb0a7d9f60837b6c9b6e"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "286173e7bde321eae67d04fa341fe32423f7cf116f13b8d96a22c35a71d07c0d"
    sha256 cellar: :any,                 arm64_tahoe:       "286173e7bde321eae67d04fa341fe32423f7cf116f13b8d96a22c35a71d07c0d"
    sha256 cellar: :any,                 arm64_sequoia:     "286173e7bde321eae67d04fa341fe32423f7cf116f13b8d96a22c35a71d07c0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7b19996bfb021f0c1ebc7baa26041be5f41c42e14ceb1d05d230a47dc06f186f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "3065e655b32a6d74fde74d8615f95e38c3103cef2253e83da5a0f19be8c9ca26"
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
