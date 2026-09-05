class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://www.contentful.com/developers/docs/tutorials/cli/"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-4.0.10.tgz"
  sha256 "5943c8645e5b1edd2cc2599cddf19cb1097a4230373ef67c71764ece042712b8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9afc61be18c076f7a77ec92e126cd73b2096af8866ee3ce246cfd933e1c1540d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9afc61be18c076f7a77ec92e126cd73b2096af8866ee3ce246cfd933e1c1540d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9afc61be18c076f7a77ec92e126cd73b2096af8866ee3ce246cfd933e1c1540d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9afc61be18c076f7a77ec92e126cd73b2096af8866ee3ce246cfd933e1c1540d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ad82352ed7c3b5871ae04dd85c740befb26941ab016acaba1e1370eee3014cd"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end
