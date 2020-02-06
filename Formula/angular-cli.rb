require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-8.3.25.tgz"
  sha256 "743792d74ccaeca898621efe9947ed69408ec338e9aec3c22e0bf1b0561a2950"

  bottle do
    cellar :any_skip_relocation
    sha256 "559b7825cbfd82c4b10faa1d622037ee9202d7fe90685fdfa0944a95d7ef0f3e" => :catalina
    sha256 "91c39480dd5ded709f7f92d96f26a3ff7ea6862ed5e0fc7d6b81f0eae0ff3d1a" => :mojave
    sha256 "f9f2f3c263aa9650047aea30f97e2843829d67ce18258c4b81766415839a176d" => :high_sierra
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
