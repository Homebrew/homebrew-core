require "language/node"

class Gitmoji < Formula
  desc "Interactive command-line tool for using emoji in commit messages"
  homepage "https://gitmoji.dev"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-9.2.0.tgz"
  sha256 "20152e6cef55ff9e84e0b14e91eac2bf6f712181b1ca54ba3ce046b0591ec0b7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e19fe318795ce8b4ebef24b473b9a84786416e765117801105fc7220a25442f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e19fe318795ce8b4ebef24b473b9a84786416e765117801105fc7220a25442f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e19fe318795ce8b4ebef24b473b9a84786416e765117801105fc7220a25442f1"
    sha256 cellar: :any_skip_relocation, sonoma:         "77931c35535978ab873c655f5710652a2c660b9b8347e8710584cefd0e1f5d42"
    sha256 cellar: :any_skip_relocation, ventura:        "77931c35535978ab873c655f5710652a2c660b9b8347e8710584cefd0e1f5d42"
    sha256 cellar: :any_skip_relocation, monterey:       "77931c35535978ab873c655f5710652a2c660b9b8347e8710584cefd0e1f5d42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e19fe318795ce8b4ebef24b473b9a84786416e765117801105fc7220a25442f1"
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
