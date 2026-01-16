class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.3.tgz"
  sha256 "80f575d4ec827a5a6e90024fd9087cc69ea274e2d08c95343f4b05c9118d7323"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f563ebba2633f6cdabcbf83e7e58eb358788b94856ab88893c2a5bc06297ac0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30166c4d20d9d448c2e26f2e47d11a0ebc2fccea20ace461a77619ded325de42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30166c4d20d9d448c2e26f2e47d11a0ebc2fccea20ace461a77619ded325de42"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e4a8a7763e41ae80154b80c044685d7094b4d49ded3a1fc01a61e8777e2ff21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6db10c69d801a9b1f1461b6e019481e7fb98f3bd1c3d2f742b155a3ac93b6b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6db10c69d801a9b1f1461b6e019481e7fb98f3bd1c3d2f742b155a3ac93b6b4"
  end

  depends_on "node"
  uses_from_macos "zlib"

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
