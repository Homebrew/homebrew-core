require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.32.0.tgz"
  sha256 "26dddc2e11c4a40868f858091b8b563e49def5aa8ddc4df636e55b1ac5c8a19d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7970f531164d33006e93b4871c417fc6d6430b6077a22b687e8b1d0808bb2e6f"
    sha256 cellar: :any,                 arm64_monterey: "7970f531164d33006e93b4871c417fc6d6430b6077a22b687e8b1d0808bb2e6f"
    sha256 cellar: :any,                 arm64_big_sur:  "7970f531164d33006e93b4871c417fc6d6430b6077a22b687e8b1d0808bb2e6f"
    sha256 cellar: :any,                 ventura:        "96e971859370c2bc2118ee69a9f06b4395a9e735c39d4e470e27dbf00bb9416f"
    sha256 cellar: :any,                 monterey:       "96e971859370c2bc2118ee69a9f06b4395a9e735c39d4e470e27dbf00bb9416f"
    sha256 cellar: :any,                 big_sur:        "96e971859370c2bc2118ee69a9f06b4395a9e735c39d4e470e27dbf00bb9416f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40752e449cea052f4b49e520d10e770f6af08791e43e8b8f0a5daf6c9da34c58"
  end

  depends_on "node"

  def install
    # Call rm -f instead of rimraf, because devDeps aren't present in Homebrew at postpack time
    inreplace "package.json", "rimraf oclif.manifest.json", "rm -f oclif.manifest.json"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Delete native binaries installed by npm, as we dont support `musl` for a `libc` implementation
    node_modules = libexec/"lib/node_modules/@asyncapi/cli/node_modules"
    (node_modules/"@swc/core-linux-x64-musl/swc.linux-x64-musl.node").unlink if OS.linux?

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    system bin/"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath/"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end
