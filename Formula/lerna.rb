require "language/node"

class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-5.1.0.tgz"
  sha256 "3421bf7697421c2b3987d1eae83e4093884a00b76033cee0703afda9ba308815"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1acf75c4163abc07b094b27e91772b63b12974abd648031bea4ad2b546c3960a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1acf75c4163abc07b094b27e91772b63b12974abd648031bea4ad2b546c3960a"
    sha256 cellar: :any_skip_relocation, monterey:       "499409470501b1757499c90050b4240bb7b0eae89112fa23dbe7b11bf682e045"
    sha256 cellar: :any_skip_relocation, big_sur:        "499409470501b1757499c90050b4240bb7b0eae89112fa23dbe7b11bf682e045"
    sha256 cellar: :any_skip_relocation, catalina:       "499409470501b1757499c90050b4240bb7b0eae89112fa23dbe7b11bf682e045"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1acf75c4163abc07b094b27e91772b63b12974abd648031bea4ad2b546c3960a"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lerna --version")

    output = shell_output("#{bin}/lerna init --independent 2>&1")
    assert_match "lerna success Initialized Lerna files", output
  end
end
