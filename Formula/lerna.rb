require "language/node"

class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-6.5.1.tgz"
  sha256 "05288dbf9c3fa5523d68ad04e80f69ba88c8e4f00b68c03bb990202d4341ea20"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "45067917276d3898dd8c418b363d65dbb45de1184553f5fbe412b993e23ee828"
    sha256                               arm64_monterey: "7abc9bc635df5d316f23102434e0e2b3603ce76c51bfad82ae7ba6c25774f6a2"
    sha256                               arm64_big_sur:  "c923c0686d0c4a9544a32e15a5519d8d810f4df9e8cf2326617fa78dd049beaa"
    sha256                               ventura:        "8c22cd2349916306bc6f5d0fb110400cc1b5751dccb7234b5e38eda17a812891"
    sha256                               monterey:       "bbbeb85fbf410676956c2f597be12ed23b4e72ad1bb442b1ae4e32c6eca0805d"
    sha256                               big_sur:        "92cb09f010da357f250e2f848e233d73c72e71c6c258b9c03e62653506fd1c1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04cc394d32304ea39c9a04383c7bd38693aceb92b16e20c5a38ef53c576fbb8d"
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
