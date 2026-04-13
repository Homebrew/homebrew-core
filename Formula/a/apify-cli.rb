class ApifyCli < Formula
  desc "Apify command-line interface"
  homepage "https://docs.apify.com/cli/"
  url "https://registry.npmjs.org/apify-cli/-/apify-cli-1.4.1.tgz"
  sha256 "5a1fc4bba4494c8c26645aa0500ed342b2fe6f5b0734f5b4e7e80cc480714256"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c2789e992b15ceb8c0a5a26dd0725b27d6a56cbc832573a868ac31f7f144e22f"
    sha256 cellar: :any,                 arm64_sequoia: "610023657207fcc28dfcc4b20b957b5efe95a0c39d2cc678fc840aff5ebd26c4"
    sha256 cellar: :any,                 arm64_sonoma:  "610023657207fcc28dfcc4b20b957b5efe95a0c39d2cc678fc840aff5ebd26c4"
    sha256 cellar: :any,                 sonoma:        "8bb86660a99d5b84727732b78152f40449f5ceeec3fa02c331cad25ef4f30c0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61eb8d0b702bcac6feeb9d2829699602751aa6160d3d2b386f892e53345b3686"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a5097c43dc348e4fbf8b19fb6dc7642245b6ecfea3ac7b7191f99e99519d317"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/apify-cli/node_modules"

    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    output = shell_output("#{bin}/apify init -y testing-actor 2>&1")
    assert_includes output, "Success: The Actor has been initialized in the current directory"
    assert_path_exists testpath/"storage/key_value_stores/default/INPUT.json"

    assert_includes shell_output("#{bin}/apify --version 2>&1"), version.to_s
  end
end
