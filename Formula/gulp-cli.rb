require "language/node"

class GulpCli < Formula
  desc "Command-line utility for Gulp"
  homepage "https://github.com/gulpjs/gulp-cli"
  url "https://registry.npmjs.org/gulp-cli/-/gulp-cli-2.3.0.tgz"
  sha256 "0a5a76e5be9856edf019fb5be0ed8501a8d815da1beeb9c6effca07a93873ba4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ea471114a8812cf87daaea09ea00dc61297ac35c4227372a9c68aaa04ed1901"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fc2ba1fab80c6b58a6f916e317141e155369834a16526ce271758f46384813a5"
    sha256 cellar: :any_skip_relocation, monterey:       "32786bd48576d4da7d9ad45254c5a414b651ec4a385db0b422fa2496a3ee6bed"
    sha256 cellar: :any_skip_relocation, big_sur:        "e011832e0a4186df90c8b6131b1ec39e60540de336bd557879351011246cfcdf"
    sha256 cellar: :any_skip_relocation, catalina:       "231b635ddf8a704a3be4a6ba34611248ece69ed1de04fb82adfa6a20ac83fddb"
    sha256 cellar: :any_skip_relocation, mojave:         "29ec2f9cf132be84c577ff6d6ea02845ee96d995e1affdea8961903f9fec616a"
    sha256 cellar: :any_skip_relocation, high_sierra:    "e4d363c9d5035fc814ca6a6820b9c8c35a320cd507067cad5eb0c0e6c337c36e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bdba5b8c37fcd4ade1460d72bc881e345b2eafbfaa0f84a57aeb19479abcaeba"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "npm", "init", "-y"
    system "npm", "install", *Language::Node.local_npm_install_args, "gulp"

    output = shell_output("#{bin}/gulp --version")
    assert_match "CLI version: #{version}", output
    assert_match "Local version: ", output

    (testpath/"gulpfile.js").write <<~EOS
      function defaultTask(cb) {
        cb();
      }
      exports.default = defaultTask
    EOS
    assert_match "Finished 'default' after ", shell_output("#{bin}/gulp")
  end
end
