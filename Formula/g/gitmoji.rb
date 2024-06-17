require "language/node"

class Gitmoji < Formula
  desc "Interactive command-line tool for using emoji in commit messages"
  homepage "https://gitmoji.dev"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-9.3.0.tgz"
  sha256 "f749a32d626c624fad489e2d2eaebf6982867a9b1fcf175dd83183edc807b980"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "904de78ea2212c2e52479539c863f2872227ab8350a3575e175b227dcd978b71"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "904de78ea2212c2e52479539c863f2872227ab8350a3575e175b227dcd978b71"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "904de78ea2212c2e52479539c863f2872227ab8350a3575e175b227dcd978b71"
    sha256 cellar: :any_skip_relocation, sonoma:         "d0aee56664d64b363611c9b1ba614a66607f5672a0f1435fb9ef70e78e57a2fb"
    sha256 cellar: :any_skip_relocation, ventura:        "d0aee56664d64b363611c9b1ba614a66607f5672a0f1435fb9ef70e78e57a2fb"
    sha256 cellar: :any_skip_relocation, monterey:       "d0aee56664d64b363611c9b1ba614a66607f5672a0f1435fb9ef70e78e57a2fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d63bc1f0194b28b4f77342da70435ea314cc89f981a79ee8666d27e0231b0f99"
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
