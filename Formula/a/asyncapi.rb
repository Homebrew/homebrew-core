class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-3.2.0.tgz"
  sha256 "e8a9f2f2939362db86b8117ae8665ae7b4808490385d614580285900486cbd9f"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d9ec6cb315aa2a5c5adf745642f0f21c17ad2c9c93fe3856332e867e55c91d20"
    sha256 cellar: :any,                 arm64_sonoma:  "d9ec6cb315aa2a5c5adf745642f0f21c17ad2c9c93fe3856332e867e55c91d20"
    sha256 cellar: :any,                 arm64_ventura: "d9ec6cb315aa2a5c5adf745642f0f21c17ad2c9c93fe3856332e867e55c91d20"
    sha256                               sonoma:        "eebcd8f05d19ba0ccac1c3b3a0a96e158a747bc00b1caa40e090b0033759ac6a"
    sha256                               ventura:       "eebcd8f05d19ba0ccac1c3b3a0a96e158a747bc00b1caa40e090b0033759ac6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fdcfdca7796c80831cda900197d035f72e67459fb0003a503e3a1274b5fa3495"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01dec2447f8b12e1f10c0dd1bb9f5e81ba6f90469c85aaa8f7482c041f652e93"
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
