require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.2.27.tgz"
  sha256 "e0a3438ca8eda913ef82c1462aa065ee18c01590e532aaf146e5a04a72fb97fa"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dd8fe211359e5f12d368b702bbc50b6e3ce3ccc52afde9d828e66e00d280a4ac" => :catalina
    sha256 "d25c9e8f696043c8d82dc4e6a80f1e445c521e8f5848d5e4fd723a7e5ceeb816" => :mojave
    sha256 "9ccdc0d8e3fb782f9329fe74192b25eadfbce6f4877bfede02d7b89818c72daf" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a managementToken via --management-Token argument", output
  end
end
