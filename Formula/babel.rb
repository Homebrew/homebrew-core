require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.21.3.tgz"
  sha256 "3195475f5e17227ed6b7d2ea3ff1b2fa53287d4a499766ab025ec2fcd26a5318"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89c7ad26989e742ada8a997e5c9fb5f644cf729bccde53a230fdb1435975b210"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89c7ad26989e742ada8a997e5c9fb5f644cf729bccde53a230fdb1435975b210"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "89c7ad26989e742ada8a997e5c9fb5f644cf729bccde53a230fdb1435975b210"
    sha256 cellar: :any_skip_relocation, ventura:        "89c7ad26989e742ada8a997e5c9fb5f644cf729bccde53a230fdb1435975b210"
    sha256 cellar: :any_skip_relocation, monterey:       "89c7ad26989e742ada8a997e5c9fb5f644cf729bccde53a230fdb1435975b210"
    sha256 cellar: :any_skip_relocation, big_sur:        "89c7ad26989e742ada8a997e5c9fb5f644cf729bccde53a230fdb1435975b210"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82944c3543d0af283252247786d7a56a872c76acfec2d1d1545845a9ab9be875"
  end

  depends_on "node"

  resource "babel-cli" do
    url "https://registry.npmjs.org/@babel/cli/-/cli-7.21.0.tgz"
    sha256 "40d4cc27188a2f9968ed8292eb4a965a460b7386719cf0e5260a82500ef777a6"
  end

  def install
    (buildpath/"node_modules/@babel/core").install Dir["*"]
    buildpath.install resource("babel-cli")

    cd buildpath/"node_modules/@babel/core" do
      system "npm", "install", *Language::Node.local_npm_install_args, "--production"
    end

    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"script.js").write <<~EOS
      [1,2,3].map(n => n + 1);
    EOS

    system bin/"babel", "script.js", "--out-file", "script-compiled.js"
    assert_predicate testpath/"script-compiled.js", :exist?, "script-compiled.js was not generated"
  end
end
