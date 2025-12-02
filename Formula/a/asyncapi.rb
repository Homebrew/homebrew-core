class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-4.1.1.tgz"
  sha256 "2f4d12597d6fc30615b6dd27fdac2c63222726005d50f62300d1f6a257f6cf61"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "e2727dfcfcf5cbf72a8d4042b91ff91d48141dc5129a78872361b1c3883caa2e"
    sha256 cellar: :any,                 arm64_sequoia: "33c0d8ad34cce095409e61751a59f1752b3aa3eefb5f87e700b81aa353b84b64"
    sha256 cellar: :any,                 arm64_sonoma:  "33c0d8ad34cce095409e61751a59f1752b3aa3eefb5f87e700b81aa353b84b64"
    sha256 cellar: :any,                 sonoma:        "588f576b6911b914ab77aa9dffb16ca16094896159d0ac682f47f7602b706ed5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a498282a790afaf15d4f21b16738d0d9de4e3324641d798075dca97c1a72208"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6cba57e348287507ec7aab8824ce25e79de1828ca504d22de3d80fd4ef1b1114"
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
