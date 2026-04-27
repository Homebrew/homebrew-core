class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.39.tgz"
  sha256 "ba5143df49d201cc05743b10673393ce9c418724f60294bf3aa2bfbe968d3b7b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d71afcda15bc8799bed2acfa647dd504d18d53fe948ab75b35dfc71c94b58143"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7740d24c0a61e946850030752e139ad7d79c3579bd841a17b04a25b25435a792"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7740d24c0a61e946850030752e139ad7d79c3579bd841a17b04a25b25435a792"
    sha256 cellar: :any_skip_relocation, sonoma:        "731709f359fcac157744dbf687b88eaa8bac08d7ca467d4974bb63f4bed11e4c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84c095891eab42d2b226cc0e2b949844184dcd3ff10491ae18ca093013fe8350"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84c095891eab42d2b226cc0e2b949844184dcd3ff10491ae18ca093013fe8350"
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
