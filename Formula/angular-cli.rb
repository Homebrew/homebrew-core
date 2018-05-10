require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-6.0.1.tgz"
  sha256 "67b88aae9ec582d7a02debf977d703f128011db917cd41ad450228a103bef0cc"

  bottle do
    sha256 "c58d8b865de16123f88340944635232167d19383ea2af13f261d4e7349dff3ca" => :high_sierra
    sha256 "b0aa7d229a8a704ae5928db5ed3f8c76bf0d0607fdfe6b06eafe0059b55be218" => :sierra
    sha256 "66f651f19d51b4455d16fda15a87fde815d6b97d814fa8fe2278cd225712f22d" => :el_capitan
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
