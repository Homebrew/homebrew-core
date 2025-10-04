class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.78.tgz"
  sha256 "13a49bdf5ecbf1b6a9b17a457cd727d2951fb083a2f5e86284f1318a4d297860"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3b205a3d10b650fb81b5d8fdf69813aad6a2799b4ae2aa65aba09f8082f2c432"
    sha256 cellar: :any,                 arm64_sequoia: "24744450307824ba9e21ffd4f7aa2015c1bf37d14f57a4e3adde1a82d5aed8f6"
    sha256 cellar: :any,                 arm64_sonoma:  "24744450307824ba9e21ffd4f7aa2015c1bf37d14f57a4e3adde1a82d5aed8f6"
    sha256 cellar: :any,                 sonoma:        "40e816a45a103b7ce79a13cbcc2465bd0308d0317963ae20d88046abb809de5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33e249bc9ac220e8ff8829b90de50585bd1a27ef91e383bc903e54f1c45ca44f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "436198c2b52f7a5b24b78840fa5954f20c73ace21c4349550d458792b111f6e5"
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
