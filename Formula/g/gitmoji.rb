class Gitmoji < Formula
  desc "Interactive command-line tool for using emoji in commit messages"
  homepage "https://gitmoji.dev"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-9.4.0.tgz"
  sha256 "edc4ac35493f321e441ab63aa2cd04f5bd315edeaf0fad952b0344f176bbde95"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "20259fe5b567622f215aab554610a0b9dca79b031eba8886621539ec514b845d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "20259fe5b567622f215aab554610a0b9dca79b031eba8886621539ec514b845d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20259fe5b567622f215aab554610a0b9dca79b031eba8886621539ec514b845d"
    sha256 cellar: :any_skip_relocation, sonoma:         "89a2544cf484c302bd704ed411e0dcae4d789c271a230103c9e9a279a50a41b5"
    sha256 cellar: :any_skip_relocation, ventura:        "89a2544cf484c302bd704ed411e0dcae4d789c271a230103c9e9a279a50a41b5"
    sha256 cellar: :any_skip_relocation, monterey:       "89a2544cf484c302bd704ed411e0dcae4d789c271a230103c9e9a279a50a41b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1af90b1631b3dbc51a16d76ae3b38c13ebf8c7bd7b6ce7524509cc6f2589bbbb"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match ":bug:", shell_output("#{bin}/gitmoji --search bug")
  end
end
