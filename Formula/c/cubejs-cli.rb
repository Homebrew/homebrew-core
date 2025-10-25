class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.83.tgz"
  sha256 "8b5095f4c39cc864a968548a2a09877899a4cca0296f029e746c90d1c71f8ad2"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "774afb64213c49ccfe5d151cabf93752d0780e3ee7e0a8f343c497a614a69c0b"
    sha256 cellar: :any,                 arm64_sequoia: "d7289f530257246ee8963b53638054637fd3bdcb3ec5afdab44c8b62fc10efd6"
    sha256 cellar: :any,                 arm64_sonoma:  "d7289f530257246ee8963b53638054637fd3bdcb3ec5afdab44c8b62fc10efd6"
    sha256 cellar: :any,                 sonoma:        "eb38ccf50858aced5656cf497a2ad69174d746222101f2ee532175f721ceb50c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d3bf9370b2da1025f27c4a2f35ee6b4c32b802be58d3b64f2a8169dfcd97cd24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed7117ba1b039a2ceb2fbbe0bfcd936eb9de710a511d81783d1bf9a5785f0ea1"
  end

  depends_on "node"
  uses_from_macos "zlib"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_path_exists testpath/"hello-world/model/cubes/orders.yml"
  end
end
