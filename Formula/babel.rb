require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.21.4.tgz"
  sha256 "01ba0b764372aef748206fe2c6122154dc03b41921256f9284e285ea61d1b449"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68cf87adae04f591dca33b5f0daed94244d9f59ed0255e59feb90a1ca74547c0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68cf87adae04f591dca33b5f0daed94244d9f59ed0255e59feb90a1ca74547c0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "68cf87adae04f591dca33b5f0daed94244d9f59ed0255e59feb90a1ca74547c0"
    sha256 cellar: :any_skip_relocation, ventura:        "68cf87adae04f591dca33b5f0daed94244d9f59ed0255e59feb90a1ca74547c0"
    sha256 cellar: :any_skip_relocation, monterey:       "68cf87adae04f591dca33b5f0daed94244d9f59ed0255e59feb90a1ca74547c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "68cf87adae04f591dca33b5f0daed94244d9f59ed0255e59feb90a1ca74547c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ba8bd7bb3196117a1154a27b225f150d013d81eab2e401bc0c416c990a486f8"
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
