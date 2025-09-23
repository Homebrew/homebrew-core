class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.68.tgz"
  sha256 "51e445945da4a0d124b04463f3a96f980d609d32a83055a27b730a64eeeabae0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d5506f527a16a20be575b2e081ece61aed0088709c65d85272137e463307b596"
    sha256 cellar: :any,                 arm64_sequoia: "9eb44909aadfa7cd6a2fc3fb1b4a068e4f8b7b4e066ae820d0bc9f9b91cc769f"
    sha256 cellar: :any,                 arm64_sonoma:  "9eb44909aadfa7cd6a2fc3fb1b4a068e4f8b7b4e066ae820d0bc9f9b91cc769f"
    sha256 cellar: :any,                 sonoma:        "09aa39f9066c334460aa064a1a0ede686a8f5a6c691a7fb6f19df0501c37918e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd510c95ab52372a4fc9efd3c6d13f00e49356f204ce9c5a74930bdc7c476892"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8117531da24c2d5e27388bb4ccca9eaae1fa1a96adc2562d0f010cbd9f075b5"
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
