require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.30.0.tgz"
  sha256 "188925b3e439cb11f27ad8d8a8a012fec519b0f8fd8e370795bfbec2dae542a4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ab205f61182529f925db576cf0ab2acd20a29f363d90e2b9e835fbd49b6928a5"
    sha256 cellar: :any,                 arm64_monterey: "ab205f61182529f925db576cf0ab2acd20a29f363d90e2b9e835fbd49b6928a5"
    sha256 cellar: :any,                 arm64_big_sur:  "ab205f61182529f925db576cf0ab2acd20a29f363d90e2b9e835fbd49b6928a5"
    sha256 cellar: :any,                 ventura:        "ee59cd0fd4c9a39cb756af9fb6ddf6d6d19d37f7fa30e5b95c66bed8423d28f7"
    sha256 cellar: :any,                 monterey:       "ee59cd0fd4c9a39cb756af9fb6ddf6d6d19d37f7fa30e5b95c66bed8423d28f7"
    sha256 cellar: :any,                 big_sur:        "ee59cd0fd4c9a39cb756af9fb6ddf6d6d19d37f7fa30e5b95c66bed8423d28f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8fe110713b0869b5011a38a5bf860d0f6cfbc6c765a33f25e5c68af979979a4"
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
