require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-7.2.3.tgz"
  sha256 "03c1a481247f37d2173a9c607dcd1572d02dda31c90198329e8397836a1c09d1"

  bottle do
    sha256 "392486a1e84eafa3df1dab5df683d728a22f05076691de9b550473e5f9212599" => :mojave
    sha256 "da239f9245b68e23f0d87b0fe6812253fa11eab8446a8a11a5dbee80940a4de4" => :high_sierra
    sha256 "eeb8020643ab135c0f8c5646647d44a66d3f01db31026c96200b4bfe1cea2bed" => :sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_predicate testpath/"angular-homebrew-test/package.json", :exist?, "Project was not created"
  end
end
