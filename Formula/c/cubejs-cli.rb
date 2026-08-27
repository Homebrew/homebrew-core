class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.7.27.tgz"
  sha256 "9419cbc7c55e7f71550cf80a98833d19e11281cc1b8eeeb1fba74723ba22c0a6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd5c50ff38328fb673d2b8aeda5c0265a839e6959769574ef4cc3b772c672998"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd5c50ff38328fb673d2b8aeda5c0265a839e6959769574ef4cc3b772c672998"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd5c50ff38328fb673d2b8aeda5c0265a839e6959769574ef4cc3b772c672998"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a588226ab83517e76d9d2d6867f232f4db4cf39f41bb21b2ab21a7cff52efbf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28979116c69275dc6e2ff8cb734e9461dc40aa2fa51480d0ac2188e4f722021d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28979116c69275dc6e2ff8cb734e9461dc40aa2fa51480d0ac2188e4f722021d"
  end

  depends_on "node"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/cubejs-cli/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_path_exists testpath/"hello-world/model/cubes/orders.yml"
  end
end
