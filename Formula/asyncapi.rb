require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.30.0.tgz"
  sha256 "188925b3e439cb11f27ad8d8a8a012fec519b0f8fd8e370795bfbec2dae542a4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "355ab317ab8305a5874bbba2cd4e42c5019f1d71da9415e15ed8c5ad412597d3"
    sha256 cellar: :any,                 arm64_monterey: "355ab317ab8305a5874bbba2cd4e42c5019f1d71da9415e15ed8c5ad412597d3"
    sha256 cellar: :any,                 arm64_big_sur:  "355ab317ab8305a5874bbba2cd4e42c5019f1d71da9415e15ed8c5ad412597d3"
    sha256 cellar: :any,                 ventura:        "1b843d40d19748d7e9da5f04b42267d1d4ac9fbb2d8147cea948f3c0f1ccfcf9"
    sha256 cellar: :any,                 monterey:       "1b843d40d19748d7e9da5f04b42267d1d4ac9fbb2d8147cea948f3c0f1ccfcf9"
    sha256 cellar: :any,                 big_sur:        "1b843d40d19748d7e9da5f04b42267d1d4ac9fbb2d8147cea948f3c0f1ccfcf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2bbd248d59b9bf9be01a82c235625aba3832add98cebb32e053259a84a68fbd7"
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
