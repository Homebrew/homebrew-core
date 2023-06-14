require "language/node"

class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-7.0.1.tgz"
  sha256 "c2d596e9c4bc720b69086fd5e894c999d7c5984f22a1c97d08ae4d6f965eff18"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "3f2e17766d5b440f7c7b53bd956dab0741f61a6bc33f906208abcad651e0084c"
    sha256                               arm64_monterey: "05001ea75b235c57f81ea439e0ebcf73fffa93543566e61a9a94e47ee61d3a03"
    sha256                               arm64_big_sur:  "4c6c98bc443d96dd17b02d1e00496c63ed026c546ff1348a581016e8d1e2cce8"
    sha256                               ventura:        "cef12ca36d3f8f3c5ff9d91ce4a934499918b1eb2fc06710d8a7554099a7d107"
    sha256                               monterey:       "4d91d26e6497775d30c2aeb77f6a4dbd2474e7a919b1ee94f03fc326459a3a05"
    sha256                               big_sur:        "767c43dfd3f7a913dd7e864c780304e84d8e6b28cea4920d5b183bd433107cd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6abf953839903ec6822116870f735950fdeadbc228fd5bdde6e39aca55a0a81b"
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
