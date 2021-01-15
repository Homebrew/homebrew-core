require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-3.1.3.tgz"
  sha256 "e52d7c88d6af42dccbf9853382038558731bfc76c6bbe9e85d8ac4df63acb3d2"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "8377811c91d70affcc113cf62be9da9fe7fd2e1109cd62abcda2e39c7f5d44ee" => :big_sur
    sha256 "4bc5e9b8e211452fe7713000af437940dec865ca6e34bab3e4cdbd6b7eede987" => :arm64_big_sur
    sha256 "a46e567d57f0baf70b77896a2246a95e1e2fb2d388abec29c50ec5721d5e2ae8" => :catalina
    sha256 "54ad61386c7d5e3c7c4c36c53dea304feb7885ebad16aa03b6ba6b1a7feb9ef3" => :mojave
  end

  depends_on "node"

  uses_from_macos "expect" => :test

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/netlify login
      expect "Opening"
    EOS
    assert_match "Logging in", shell_output("expect -f test.exp")
  end
end
