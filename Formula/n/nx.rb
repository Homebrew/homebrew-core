class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-24.1.0.tgz"
  sha256 "9d6a88c36ccae7aad4ddb295f44ce062792ceabb2cc36cc824715ede98544f5b"
  license "MIT"
  version_scheme 1

  bottle do
    manifest_sha256 "f203398345d3c7f8be2dffcca7ddef6d6eb555d1403261e3be8466fa2766957b"
    sha256 cellar: :any,                 arm64_golden_gate: "cfbc54e3f1d18a31df896b1449526f62a428d9b9a39998bdb241d6c06ba19891"
    sha256 cellar: :any,                 arm64_tahoe:       "cfbc54e3f1d18a31df896b1449526f62a428d9b9a39998bdb241d6c06ba19891"
    sha256 cellar: :any,                 arm64_sequoia:     "cfbc54e3f1d18a31df896b1449526f62a428d9b9a39998bdb241d6c06ba19891"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "44ee583d1e960b63d909172711d011a91347ed00913b8f56b5adff678918fb9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "791fcbc375c80631acb01940db0edae20a6c3dd819d0be71213dbcb812f0ded8"
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
