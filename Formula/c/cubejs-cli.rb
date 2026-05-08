class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.44.tgz"
  sha256 "279c32dc04b211439c8bfedaae1aa11a8ef83af6e10b1b49f1400d3a58c40380"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10007dffedbc75312a98eaa394ea9c47447ce29a26bcd6a89ba3b24ea91237ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0dadf29376589d75181f6a4ec7ca47d88412d8c63dca00b81f6c77939c5b9e42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0dadf29376589d75181f6a4ec7ca47d88412d8c63dca00b81f6c77939c5b9e42"
    sha256 cellar: :any_skip_relocation, sonoma:        "f61694bab20a61392db7d7469672054211bcc4b1695f3ff74616e6a20b038b55"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "823bd1f0117f883d71aac704534ca74246f6f18f8a6afc15f3703319fb0c5c22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "823bd1f0117f883d71aac704534ca74246f6f18f8a6afc15f3703319fb0c5c22"
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
