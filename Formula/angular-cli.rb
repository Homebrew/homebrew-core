require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-15.2.6.tgz"
  sha256 "5b5b4122499fbb3aa8ca88e53d4bd226997c9dc170c9a366154e04704a934b6c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "50e9ab652ec707d9ba6891874687a3f026cebcd9830609f7f3b5931bc9eb06e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50e9ab652ec707d9ba6891874687a3f026cebcd9830609f7f3b5931bc9eb06e3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "50e9ab652ec707d9ba6891874687a3f026cebcd9830609f7f3b5931bc9eb06e3"
    sha256 cellar: :any_skip_relocation, ventura:        "56c838d4781ac9009b5915d9c5def79b33b1162050ab303497a52d6978d30520"
    sha256 cellar: :any_skip_relocation, monterey:       "56c838d4781ac9009b5915d9c5def79b33b1162050ab303497a52d6978d30520"
    sha256 cellar: :any_skip_relocation, big_sur:        "56c838d4781ac9009b5915d9c5def79b33b1162050ab303497a52d6978d30520"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50e9ab652ec707d9ba6891874687a3f026cebcd9830609f7f3b5931bc9eb06e3"
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
