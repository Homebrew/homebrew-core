class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-3.1.1.tgz"
  sha256 "7156fdd3ab24df4aaf513fa7fec736e3b7297417d5156db8a4dfce7edb1789c9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "198a12f3799fb1d2e8477b8b48898eb42a8048a7c71a800eac8b3c97810f2fe8"
    sha256 cellar: :any,                 arm64_sonoma:  "198a12f3799fb1d2e8477b8b48898eb42a8048a7c71a800eac8b3c97810f2fe8"
    sha256 cellar: :any,                 arm64_ventura: "198a12f3799fb1d2e8477b8b48898eb42a8048a7c71a800eac8b3c97810f2fe8"
    sha256 cellar: :any,                 sonoma:        "47ee08e3f36f98384a161d34f3d8eea341269da2016a07a1b214a8c76e857c67"
    sha256 cellar: :any,                 ventura:       "47ee08e3f36f98384a161d34f3d8eea341269da2016a07a1b214a8c76e857c67"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "100636a8514bb785ac9359a45fcc4168f10e4c7c4e42bd9354afe5b78d6da078"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34ffbb83acc1bdf4b85a990e9dc74945d4d1574aa4026be94e7b18e4a1748a48"
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
