require "language/node"

class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-7.3.0.tgz"
  sha256 "7ea25409e03fb135be6c96425db82f430331a3158b00966ce9b208f7b15a75a1"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "9ad3e866b264995a689b25b55b71325762c4e54ea73b656361f8d7bccb354dc0"
    sha256                               arm64_monterey: "2f1241aa93ae2d75872b9ec7b1ac60ba5b4f3e235b5b0227585a4ec9b7004495"
    sha256                               arm64_big_sur:  "bc554fd30060b2710ec6e4e222ae8707f732740c2e322882cd2f453f34511db1"
    sha256                               ventura:        "21205f2b4cb6243d2d771c83a59ee06eeecdf0ddc89fec5ec3f93887da10ef4c"
    sha256                               monterey:       "bd9ed15c741f660c486a707ac6823d216e22d35edf616dd48e4d3fbb3c62be89"
    sha256                               big_sur:        "1fd71084d0451618f663cf7ee72d612d14d6d3da6fc284d46651ef6052af9d27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23099b4ec88bc972782921702d0553f7e50ba34bd2eaf4c558552e2e51b8ed7d"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/lerna/node_modules"
    (node_modules/"@parcel/watcher/prebuilds/linux-x64/node.napi.musl.node").unlink
    (node_modules/"@nx/nx-linux-x64-musl/nx.linux-x64-musl.node").unlink if OS.linux?
    (node_modules/"@parcel/watcher/prebuilds").each_child { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lerna --version")

    output = shell_output("#{bin}/lerna init --independent 2>&1")
    assert_match "lerna success Initialized Lerna files", output
  end
end
