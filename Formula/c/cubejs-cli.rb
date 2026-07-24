class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.7.10.tgz"
  sha256 "7bb5cca93b6f1ea4613dd2c5dd428b27ab36cf838dcbdf005dcf64a5d98533d2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd365d4ab7b5cd30b6c7324e64e0ab77a950f99545e1e79d1b9c8812cede9987"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd365d4ab7b5cd30b6c7324e64e0ab77a950f99545e1e79d1b9c8812cede9987"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd365d4ab7b5cd30b6c7324e64e0ab77a950f99545e1e79d1b9c8812cede9987"
    sha256 cellar: :any_skip_relocation, sonoma:        "8af717d1f82c582e0506c65ff30d4d4f2d258aedc759e41d8f4150a08af08544"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d366ed921160bde96e16919eba96e1b2b16e36f56cc2f0a618688d43edc902a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d366ed921160bde96e16919eba96e1b2b16e36f56cc2f0a618688d43edc902a"
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
