require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.9.25.tgz"
  sha256 "731b37bbd974e5d1ef522479533e9e4940247b42c41deb1b1bbd1af0d225c3cd"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b868f5468a25a1fbe73350c1bde1dd0af70eb43dce78813a5015beed04499bda"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d7e5812a10ab8d11aadcaff09d5c098e32423747682cd286ac31063972864ba6"
    sha256 cellar: :any_skip_relocation, monterey:       "8d4debeff6eccb202febb15efd318fc39db55f2c8244bcfb02deee4834f79895"
    sha256 cellar: :any_skip_relocation, big_sur:        "e30938329ad422e06d4e29e8fbbc5419671ce1296ed49f75a7e2b1d272b71206"
    sha256 cellar: :any_skip_relocation, catalina:       "e30938329ad422e06d4e29e8fbbc5419671ce1296ed49f75a7e2b1d272b71206"
    sha256 cellar: :any_skip_relocation, mojave:         "e30938329ad422e06d4e29e8fbbc5419671ce1296ed49f75a7e2b1d272b71206"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b15f506d5549c35b8de0865215155e460f72d5c4ef32603b37d7041df56b45f6"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end
