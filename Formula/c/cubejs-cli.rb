class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.54.tgz"
  sha256 "0fd0d1b999ea8276b048e35b028069db504fc218edaa999d9e2ab031c252a124"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f92532f24c029161ce493081d2037cb9bde547aaca087348106492a81816676d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e7819075fc1e1ca10fbbc31a3b16774bb6896e13a2641f79e27991d0cfbb91d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e7819075fc1e1ca10fbbc31a3b16774bb6896e13a2641f79e27991d0cfbb91d"
    sha256 cellar: :any_skip_relocation, sonoma:        "450125e8a5a89c412997fd75a1ad51cb0148e3fc345aa1b9a98b1ab9bd34f913"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6dd2331b1b0cbdf6e533e49553e2d041b8e0b5b8e71ce3093eb7dcb6a21e1e7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6dd2331b1b0cbdf6e533e49553e2d041b8e0b5b8e71ce3093eb7dcb6a21e1e7d"
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
