require "language/node"

class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-6.6.2.tgz"
  sha256 "07ea3a4b0553ae8b47358256e8251753fac92cad957861ef658419a9b8585a38"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "c03df5d496488224f1cdb8d6198979e39b7e04e94abf1bcd1c0e63313c5a87ec"
    sha256                               arm64_monterey: "4c6ef95805aaa54fdad1d5ed1f2c20d2dbecad70c60ca03f3e44bc3aaf029e8c"
    sha256                               arm64_big_sur:  "cc294279ccc8c82c0a90e3d187f2e31083236f82c81f3a14605f3a439e1a7dcd"
    sha256                               ventura:        "c0de73bb2960ff67ca829afc5893949e743cff557b1651c6a36575de725eb037"
    sha256                               monterey:       "cefea619eea3e2b1e4b03e4a3ad446985e396603fa98abbaca0a275fd2fd1abd"
    sha256                               big_sur:        "5063f1a1bba617f88ce8f4f0e7f7f31953503ac3e49ee7161cbbf76e32b235b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92208ca10bd18e6f381b091185576fdc7db2ab5d7ab5bb815128a0466c1e0866"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/lerna/node_modules"
    (node_modules/"@parcel/watcher/prebuilds/linux-x64/node.napi.musl.node").unlink
    (node_modules/"@nrwl/nx-linux-x64-musl/nx.linux-x64-musl.node").unlink if OS.linux?
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
