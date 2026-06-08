class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-22.7.5.tgz"
  sha256 "a3e5c3ff2c674e6d56f7d54d50a39287abbe2fe554d03d7c1faeb8a9711adb42"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e3a9d18ae6952425bc6d85ef1e6c8b8270dc1e77f1457b1776af2a4c4686648f"
    sha256 cellar: :any,                 arm64_sequoia: "07c2ebfb14f67d8f41fee5c0c42ec417ed418363aa6aaab823950893f9f18134"
    sha256 cellar: :any,                 arm64_sonoma:  "07c2ebfb14f67d8f41fee5c0c42ec417ed418363aa6aaab823950893f9f18134"
    sha256 cellar: :any,                 sonoma:        "063c83d76ca1087d353e842e1a31132a7279e64e770058d21c9ed35d85660bea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee2c35e5fba7a49f77b073b87c1ee9a22b3022b0afba8431d730f7483104aab2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23a450b449c7df522bd8d8e4767b4bb2bf3e1390540dcd0e1a463deecace9e16"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
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
