require "language/node"

class Hexo < Formula
  desc "Fast, simple & powerful blog framework"
  homepage "https://hexo.io/"
  url "https://registry.npmjs.org/hexo/-/hexo-7.1.1.tgz"
  sha256 "34e153e09d478931f49c0564d75f9b4b7d0a5f1687c836b025172c37a594b038"
  license "MIT"
  head "https://github.com/hexojs/hexo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "606cd3fd72fb52fe4eee8ad7a7117eef1327f46a7881af815bb377c7ec9f93da"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "606cd3fd72fb52fe4eee8ad7a7117eef1327f46a7881af815bb377c7ec9f93da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "606cd3fd72fb52fe4eee8ad7a7117eef1327f46a7881af815bb377c7ec9f93da"
    sha256 cellar: :any_skip_relocation, sonoma:         "a798b69ad05fc4e6d8108e8b43be7333eb78b5f049d30eae7cf8477042366082"
    sha256 cellar: :any_skip_relocation, ventura:        "a798b69ad05fc4e6d8108e8b43be7333eb78b5f049d30eae7cf8477042366082"
    sha256 cellar: :any_skip_relocation, monterey:       "a798b69ad05fc4e6d8108e8b43be7333eb78b5f049d30eae7cf8477042366082"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9e57d3bb5ad775d38fd9bd162a3123b7e52acf45bce5d192d0442d8a45270ce"
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
