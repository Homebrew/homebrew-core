require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-3.1.1.tgz"
  sha256 "18cd49eb2838d131f816b79a69ff32f320efd796cd3d3ce1715ab13db1fcca50"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "77e3e8f36b08d55fab10d8a28b72bb6d7030c5436e8ac2647d84bd72156d6203" => :big_sur
    sha256 "d974286a1e7cf9e643dc1ee043edc927946a73f0e4a7d7c6cdb0beb16913270b" => :arm64_big_sur
    sha256 "98dc70c6933ac5d79454fe8c70f6ed1a45d0c8bc514935012e5ea40243e3ae99" => :catalina
    sha256 "4fc455eac88b7b5f2d6eb04c7057538d60b259fd4f6cc6c594518bbe0b0e2c1c" => :mojave
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
