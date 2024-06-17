require "language/node"

class Hexo < Formula
  desc "Fast, simple & powerful blog framework"
  homepage "https://hexo.io/"
  url "https://registry.npmjs.org/hexo/-/hexo-7.2.0.tgz"
  sha256 "26e9a3261d7c7dc121be04cc9c592164a2504f2a1940dab0f0a2447ded32c879"
  license "MIT"
  head "https://github.com/hexojs/hexo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dc40e8514a0603fb74883411c97cea3d88dd7c86b4069bdfeb62a83efea9a45b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc40e8514a0603fb74883411c97cea3d88dd7c86b4069bdfeb62a83efea9a45b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc40e8514a0603fb74883411c97cea3d88dd7c86b4069bdfeb62a83efea9a45b"
    sha256 cellar: :any_skip_relocation, sonoma:         "7f8b1c9b0c279a2506756bdf41ed8462e76997536583f8d005afa5d22aadb700"
    sha256 cellar: :any_skip_relocation, ventura:        "7f8b1c9b0c279a2506756bdf41ed8462e76997536583f8d005afa5d22aadb700"
    sha256 cellar: :any_skip_relocation, monterey:       "7f8b1c9b0c279a2506756bdf41ed8462e76997536583f8d005afa5d22aadb700"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc40e8514a0603fb74883411c97cea3d88dd7c86b4069bdfeb62a83efea9a45b"
  end

  depends_on "node"

  def install
    mkdir_p libexec/"lib"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with their native slices.
    deuniversalize_machos
  end

  test do
    output = shell_output("#{bin}/hexo --help")
    assert_match "Usage: hexo <command>", output.strip

    output = shell_output("#{bin}/hexo init blog --no-install")
    assert_match "Cloning hexo-starter", output.strip
    assert_predicate testpath/"blog/_config.yml", :exist?
  end
end
