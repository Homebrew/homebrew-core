require "language/node"

class Gitmoji < Formula
  desc "Interactive command-line tool for using emoji in commit messages"
  homepage "https://gitmoji.dev"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-4.5.1.tgz"
  sha256 "f5ecf2db509e99fc9459edcd453dde2c989f4c2ff7570de633e6d61ca8e78af6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c10652b68154f242ec890aa708ee6ef921513e3629fd2dbf0077236296e2b924"
    sha256 cellar: :any_skip_relocation, big_sur:       "6edfdc5bbf36f1ec18f0d3e09367c698d9c43d240e197dc4293ecf60032659be"
    sha256 cellar: :any_skip_relocation, catalina:      "6edfdc5bbf36f1ec18f0d3e09367c698d9c43d240e197dc4293ecf60032659be"
    sha256 cellar: :any_skip_relocation, mojave:        "6edfdc5bbf36f1ec18f0d3e09367c698d9c43d240e197dc4293ecf60032659be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c10652b68154f242ec890aa708ee6ef921513e3629fd2dbf0077236296e2b924"
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
