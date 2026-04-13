class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.33.tgz"
  sha256 "489264fdc785d1b10be9e92718699fbf7a0a242aa07f008b7449c6b23f23098d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e8ef43c4dd11da4ab8722e492f6bc6dca1f9fbb7a30ff6889b091786efec5d96"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "194052693e4a164ec3fe758fb9b37fac225562930e173bc4a834800d0e63209a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "194052693e4a164ec3fe758fb9b37fac225562930e173bc4a834800d0e63209a"
    sha256 cellar: :any_skip_relocation, sonoma:        "4030a02c69bf3834c805b15173cbc94c5f91ec30c5717ac584fac7300796e925"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66675a669be4ef965164da035f456a399b9d5bf885bc308ff4d6a617cb3e551e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66675a669be4ef965164da035f456a399b9d5bf885bc308ff4d6a617cb3e551e"
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
