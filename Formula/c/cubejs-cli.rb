class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.69.tgz"
  sha256 "ece1ebf34867c5e0123e6d94ec2c5efc09357137fa8cd7f8d49f76c915e1eb39"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "64db9c611fe1fb7dee255d806e88b2c5db1f9c0ead1c02d0426e758be4f8d93e"
    sha256 cellar: :any,                 arm64_sequoia: "e2dfdb6ba0337ccd434626f0b6d600b615d1dd70042f8de9a0ed126234087b65"
    sha256 cellar: :any,                 arm64_sonoma:  "e2dfdb6ba0337ccd434626f0b6d600b615d1dd70042f8de9a0ed126234087b65"
    sha256 cellar: :any,                 sonoma:        "bba8a3606e27dd6739cc42c3060b90428c28f5e787c2bba01f8e3859df4a473b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "061c385e9b4e2b15660d54e224d6b8004af396c99b5b25e8c51714aacdfcad56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a4c6bcc03f9c488dd9373e5b5e5ad22489d26e7dbff73cd1b024d87020499f4"
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
