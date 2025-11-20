class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-4.1.1.tgz"
  sha256 "2f4d12597d6fc30615b6dd27fdac2c63222726005d50f62300d1f6a257f6cf61"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3ebd61013a46b45e87e720f6a29a01b21f30284eb2cc189b64192b4ada07bf39"
    sha256 cellar: :any,                 arm64_sequoia: "7aef6cc320594a4a347ed4cb8d2b233aa62fa6bf6d58e485eacf7f95a558cab2"
    sha256 cellar: :any,                 arm64_sonoma:  "7aef6cc320594a4a347ed4cb8d2b233aa62fa6bf6d58e485eacf7f95a558cab2"
    sha256 cellar: :any,                 sonoma:        "256cfaa02cb30e5633444226e24db3820b4008faf720552b28b162bff96f04d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7db0c88cd1cdec73bff3052af77a3ced1082ca4d5b8b76d77b038910bea805e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b598c9f62a1fc12200cb19235a92224b7cbb94eb3b890fc1d0f317449d97de7"
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
