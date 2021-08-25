require "language/node"

class Gitmoji < Formula
  desc "Interactive command-line tool for using emoji in commit messages"
  homepage "https://gitmoji.dev"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-4.5.1.tgz"
  sha256 "f5ecf2db509e99fc9459edcd453dde2c989f4c2ff7570de633e6d61ca8e78af6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7d88a3ff38ccadae7fcec5cc0e9450a13f554500f82530cfd6dcc0b82049ec63"
    sha256 cellar: :any_skip_relocation, big_sur:       "3bf9a356831b35a2dd7718643bb067982d6133e365f6b7e72603fe6b182bf00b"
    sha256 cellar: :any_skip_relocation, catalina:      "3bf9a356831b35a2dd7718643bb067982d6133e365f6b7e72603fe6b182bf00b"
    sha256 cellar: :any_skip_relocation, mojave:        "3bf9a356831b35a2dd7718643bb067982d6133e365f6b7e72603fe6b182bf00b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d88a3ff38ccadae7fcec5cc0e9450a13f554500f82530cfd6dcc0b82049ec63"
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
