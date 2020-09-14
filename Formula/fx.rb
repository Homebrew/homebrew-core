require "language/node"

class Fx < Formula
  desc "Command-line JSON processing tool"
  homepage "https://github.com/antonmedv/fx"
  url "https://registry.npmjs.org/fx/-/fx-20.0.1.tgz"
  sha256 "0f70e9a833cb73e24cc01fced168dd1fa235472766221d60c1ff3fe8e9822d7f"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "accecb7e1d80c5fdde293f54cc7c5ff62bbfda653ca77d0e6b79e5d8cf15423e" => :catalina
    sha256 "242662e5cac879761639076d0587db86ebafc7f90e94c825ad149e7dd4b2c2f9" => :mojave
    sha256 "97c2744a7c63df0ccd5bf8f7d60fbe8e4a09fbcc8abda2a91c5cde259f93626e" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "bar", shell_output("echo '{\"foo\": \"bar\"}' #{bin}/fx .foo")
  end
end
