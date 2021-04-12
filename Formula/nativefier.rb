require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/jiahaog/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-43.0.1.tgz"
  sha256 "c490116f49b446cb8a8bf8f7f66cf35cf3227c68c50b69982332e11137526d48"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f0bebd3923d1ec5cec8496a2c7b64d5058fd1767024d0726e397da640215d6e8"
    sha256 cellar: :any_skip_relocation, big_sur:       "4a1b13ffb971dcccc22ca9399268d5f743ad4878972f16f876d12c7d450feac5"
    sha256 cellar: :any_skip_relocation, catalina:      "52dcbf36dbe9463ea95a68dc3308bc17169af4b74db6664a88208175b6517a72"
    sha256 cellar: :any_skip_relocation, mojave:        "ad1d0bf3905d55bb2c43f1ad89ff3526f6c1e83152d62e8e5cde1593dd12e644"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nativefier --version")
  end
end
