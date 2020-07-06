require "language/node"

class Gitmoji < Formula
  desc "Emoji guide for your commit messages"
  homepage "https://gitmoji.carloscuesta.me"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-3.2.6.tgz"
  sha256 "e10d84ee451f236e3be5ed487557c4b7bab46338d5115f5c58ecf4f6862b8bd6"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "625e829cad6317c55ba225ad7429bdc44b5f2f0e8542913150fdbcf995f72cda" => :catalina
    sha256 "0a9e423e8d354c7a1b5dac4cc8aee6455c54081bc5a6f81fdf1d987afc0a1dd1" => :mojave
    sha256 "61f3bfbad5458f75bbaf554eeca5d6840a0aaa1e27702ef210a6ec3aed81013f" => :high_sierra
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
