class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.75.tgz"
  sha256 "9579eef7789857b1930d06b4c601353d1e6695b29633584e9499736aa63dd0cc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9fd2b238233ebf6afabda736a8a2e5b81153d7337a6be668fb8300a49bb06fd9"
    sha256 cellar: :any,                 arm64_sequoia: "f1eb2a86ef1965c037adcd6d748024f604dd483c64f8d1c4ceda94789dd24c05"
    sha256 cellar: :any,                 arm64_sonoma:  "f1eb2a86ef1965c037adcd6d748024f604dd483c64f8d1c4ceda94789dd24c05"
    sha256 cellar: :any,                 sonoma:        "af6126100b1aa6607bb966737b07b21ad5eaef8cf11d570d4e39f7ed6d061f51"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b77772ad8f91a5bbb71b70b05b1bf3fb9ad7aa8852fa4d8997ffdd1b247c43a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b091b08a459b24ce29930b911299da5c4707eb02032f04df7bef3c08ae2b488"
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
