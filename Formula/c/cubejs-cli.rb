class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.5.4.tgz"
  sha256 "2c13e4367ac494be386676dc69935c506b0d627d5a50fa75b19713080201a39e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a30749c11197b5107eeb20422c65b36153e379c8192a1c7360021e409705376e"
    sha256 cellar: :any,                 arm64_sequoia: "add1c12af9cbecf2b9dec07c40bb4006b625b6edf2a77d1046739e225ff99e07"
    sha256 cellar: :any,                 arm64_sonoma:  "add1c12af9cbecf2b9dec07c40bb4006b625b6edf2a77d1046739e225ff99e07"
    sha256 cellar: :any,                 sonoma:        "5cf2a759a981cacf75348c0a40c29ad6df128bb1690d710678c657f6acc965e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4cd81668fec9bc3c34e5a8b1e4c1e854bb5cacd300c0d636adaaeea64047bc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d89eba928a816c9c46833ada987d81499b244669f1d983f587359ae05ec74389"
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
