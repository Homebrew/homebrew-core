require "language/node"

class Opencommit < Formula
  desc "GPT CLI to auto-generate impressive commits in 1 second"
  homepage "https://github.com/di-sukharev/opencommit"
  url "https://registry.npmjs.org/opencommit/-/opencommit-2.0.0.tgz"
  sha256 "583391f0dec09fb2a17a7a06d963ff4424e7c69f1635368916e3c1227518cce5"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "For help look into README https://github.com/di-sukharev/opencommit#setup",
shell_output("#{bin}/opencommit", 1)

    system "git", "init"
    assert_match "For help look into README https://github.com/di-sukharev/opencommit#setup",
      shell_output("#{bin}/opencommit", 1)
  end
end
