require "language/node"

class GulpCli < Formula
  desc "Command-line utility for Gulp"
  homepage "https://github.com/gulpjs/gulp-cli"
  url "https://registry.npmjs.org/gulp-cli/-/gulp-cli-2.3.0.tgz"
  sha256 "0a5a76e5be9856edf019fb5be0ed8501a8d815da1beeb9c6effca07a93873ba4"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "231b635ddf8a704a3be4a6ba34611248ece69ed1de04fb82adfa6a20ac83fddb" => :catalina
    sha256 "29ec2f9cf132be84c577ff6d6ea02845ee96d995e1affdea8961903f9fec616a" => :mojave
    sha256 "e4d363c9d5035fc814ca6a6820b9c8c35a320cd507067cad5eb0c0e6c337c36e" => :high_sierra
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
