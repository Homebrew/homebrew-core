require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.23.9.tgz"
  sha256 "c07d625e1242538f22e6638ab88d8036dee1a7bfcb4ff181b772af80379b5ec3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "19a2d4bbe0849ca4185ecf88a958223b76bdffb090b9ffddae1263a311ec2382"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "19a2d4bbe0849ca4185ecf88a958223b76bdffb090b9ffddae1263a311ec2382"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19a2d4bbe0849ca4185ecf88a958223b76bdffb090b9ffddae1263a311ec2382"
    sha256 cellar: :any_skip_relocation, sonoma:         "19a2d4bbe0849ca4185ecf88a958223b76bdffb090b9ffddae1263a311ec2382"
    sha256 cellar: :any_skip_relocation, ventura:        "19a2d4bbe0849ca4185ecf88a958223b76bdffb090b9ffddae1263a311ec2382"
    sha256 cellar: :any_skip_relocation, monterey:       "19a2d4bbe0849ca4185ecf88a958223b76bdffb090b9ffddae1263a311ec2382"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2166cd6f8c9d1eeb3662bfe74d4a8aa9b14887e84c9f14cf2579d3857951e544"
  end

  depends_on "node"

  resource "babel-cli" do
    url "https://registry.npmjs.org/@babel/cli/-/cli-7.23.4.tgz"
    sha256 "d68b7484904de1c6b3057ea473d39e9c0224c1f9300f73947985e19255f5e873"
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
