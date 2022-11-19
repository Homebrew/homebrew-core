require "language/node"

class Gitmoji < Formula
  desc "Interactive command-line tool for using emoji in commit messages"
  homepage "https://gitmoji.dev"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-7.0.2.tgz"
  sha256 "d6893be216fdb67f24474acf4270c932b4c1486e65941c969a122df8b0ca23cc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c681d8b11bf4d1d2b222d5f3a7ecd0caff3e1219b90bc4ccf9fce90b93bea3c8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59698c09b6a5fdce0020c72da31316f4ce71a8aa3047d120fb444c4c394c2049"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "59698c09b6a5fdce0020c72da31316f4ce71a8aa3047d120fb444c4c394c2049"
    sha256 cellar: :any_skip_relocation, ventura:        "559c0f5d373551ecbbfe226b4b609fbb048298fc4c85724eca50c3fe81789c5e"
    sha256 cellar: :any_skip_relocation, monterey:       "2c95ef77973d474bdee265707d0fd4eb7d119b57ccd766ba95d2d2daf358ae3d"
    sha256 cellar: :any_skip_relocation, big_sur:        "2c95ef77973d474bdee265707d0fd4eb7d119b57ccd766ba95d2d2daf358ae3d"
    sha256 cellar: :any_skip_relocation, catalina:       "2c95ef77973d474bdee265707d0fd4eb7d119b57ccd766ba95d2d2daf358ae3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59698c09b6a5fdce0020c72da31316f4ce71a8aa3047d120fb444c4c394c2049"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match ":bug:", shell_output("#{bin}/gitmoji --search bug")
  end
end
