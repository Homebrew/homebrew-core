class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.7.42.tgz"
  sha256 "de30ad7a1fbeedfeb6bb88b70a9d69a481c3203b8ca55d70d281d232ac71bead"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "092b7c6b638e38feab37cb1f9bdce2c3ec189bf3d5e5bc84431b6582c75591c9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "092b7c6b638e38feab37cb1f9bdce2c3ec189bf3d5e5bc84431b6582c75591c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "092b7c6b638e38feab37cb1f9bdce2c3ec189bf3d5e5bc84431b6582c75591c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5465aad31d4449976be24df638696db9f028d63317d7029154df44a88bdb7379"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "5465aad31d4449976be24df638696db9f028d63317d7029154df44a88bdb7379"
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
