class Docmd < Formula
  desc "Minimal Markdown documentation generator"
  homepage "https://docmd.mgks.dev/"
  url "https://registry.npmjs.org/@docmd/core/-/core-0.6.3.tgz"
  sha256 "612f132d7f2a7d9e9c9d29cdb2573f4ce1ff52bcdd61425ee3ebb7b0c52fb65c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "45aa8fc3d7b96a53a56015394e6f659aaa63ff84064bb42cef17b7c8c2040780"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37f938031a9c76c9805cdfb0172412e2caf32b297b8d081b071872388ff6fae9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37f938031a9c76c9805cdfb0172412e2caf32b297b8d081b071872388ff6fae9"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b5fb4ff9eda9bd01d4ee26594d785a91965b20aa5518c373456fceddb3544e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59a3c7addacc11b127d3bdd40f8b4be4ddbaeeb3b83b53306bc0cc0a1b35197c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59a3c7addacc11b127d3bdd40f8b4be4ddbaeeb3b83b53306bc0cc0a1b35197c"
  end

  depends_on "esbuild" # for prebuilt binaries
  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@docmd/core/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?

    # Remove pre-built binaries
    rm_r(libexec/"lib/node_modules/@docmd/core/node_modules/@esbuild")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/docmd --version")

    system bin/"docmd", "init"
    assert_path_exists testpath/"docmd.config.js"
    assert_match 'title: "Welcome"', (testpath/"docs/index.md").read
  end
end
