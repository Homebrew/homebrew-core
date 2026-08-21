class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.7.24.tgz"
  sha256 "2f5dc58d27187bc223751cf9d6afcfb2112f51e39c071c8804e227bcef729e20"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c7b6142198bf6ab8683e486f6538ce7967264fa73142bf80cbd1a55a47a5f40a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7b6142198bf6ab8683e486f6538ce7967264fa73142bf80cbd1a55a47a5f40a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7b6142198bf6ab8683e486f6538ce7967264fa73142bf80cbd1a55a47a5f40a"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc5da069b2af435476c69441cde2a6d0172593069bcbd7580a93a58d4c7196fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "982ad520a3ccd0b797a5be9686e1e7848eafddb5e2d18d298926befe0049b975"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "982ad520a3ccd0b797a5be9686e1e7848eafddb5e2d18d298926befe0049b975"
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
