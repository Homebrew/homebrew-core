require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-9.1.5.tgz"
  sha256 "9b813d8010dd351295f5aa044a67bb1f8bfb51509dd1c5fbbd29d8c8ad8ef7cf"

  bottle do
    cellar :any_skip_relocation
    sha256 "27c08b659f67f2691d8400a4433cd0c5188591ca639d29680191f23d6077765b" => :catalina
    sha256 "795959e8028812cc00c55309ce2caaed346d4571b5589de2ce02c020eda3948a" => :mojave
    sha256 "f1cc9b52a1d580bc2578bc5c81783cdf8c88d14cd9f2b78a14e49907b374c435" => :high_sierra
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
