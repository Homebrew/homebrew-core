class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.24.tgz"
  sha256 "e6e22ccf03f118afe061afcc064f3580e09ef1892f028f37e0a5148489a89ec2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5598ea4db4e26651984161b5a02d24ff83f8f1289083b226a308eb961d61df5f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56d1f704327272de5e6a13db60923cfb4424e3bd44cc73708d1b0bbfb635b462"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56d1f704327272de5e6a13db60923cfb4424e3bd44cc73708d1b0bbfb635b462"
    sha256 cellar: :any_skip_relocation, sonoma:        "adf8610694794e4755b3b0d40c4973cd38325177da3d4d30be585029919356c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25ed3deb295c394dc8d3e66fb280afedd1dbd9be9752b8dd899eec139cd8f124"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25ed3deb295c394dc8d3e66fb280afedd1dbd9be9752b8dd899eec139cd8f124"
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
