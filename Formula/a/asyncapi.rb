class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-3.1.1.tgz"
  sha256 "7156fdd3ab24df4aaf513fa7fec736e3b7297417d5156db8a4dfce7edb1789c9"
  license "Apache-2.0"

  # https://github.com/asyncapi/cli/blob/master/.github/workflows/bump-homebrew-formula.yml
  livecheck do
    skip "Developers bump Homebrew formula themselves"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a0bff8b9cb9ebcd8afbdb064897c62ac41068b09e01427ebba5f1255c31a9fc0"
    sha256 cellar: :any,                 arm64_sonoma:  "a0bff8b9cb9ebcd8afbdb064897c62ac41068b09e01427ebba5f1255c31a9fc0"
    sha256 cellar: :any,                 arm64_ventura: "a0bff8b9cb9ebcd8afbdb064897c62ac41068b09e01427ebba5f1255c31a9fc0"
    sha256 cellar: :any,                 sonoma:        "046898eeb40e36ffdfe28509a8d9856abc5fce78f18045b4f27080eb5a4099b4"
    sha256 cellar: :any,                 ventura:       "046898eeb40e36ffdfe28509a8d9856abc5fce78f18045b4f27080eb5a4099b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f018bca7ce9121001748a8e90cbd4636f450bf5f56610338a38dcaeb72fe1e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5b26e7065b3aba14fb6e6becb7f1ac5a618b9a4be7e567015cf76224b4a7328"
  end

  depends_on "node"

  def install
    system "npm", "install", "--ignore-scripts", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Cleanup .pnpm folder
    node_modules = libexec/"lib/node_modules/@asyncapi/cli/node_modules"
    rm_r (node_modules/"@asyncapi/studio/build/standalone/node_modules/.pnpm") if OS.linux?

    # Replace universal binaries with their native slices
    deuniversalize_machos node_modules/"fsevents/fsevents.node"
  end

  test do
    system bin/"asyncapi", "new", "file", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_path_exists testpath/"asyncapi.yml", "AsyncAPI file was not created"
  end
end
