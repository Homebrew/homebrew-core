require "language/node"

class Autocode < Formula
  desc "Code automation for every language, library and framework"
  homepage "https://autocode.run"
  url "https://registry.npmjs.org/autocode/-/autocode-1.3.1.tgz"
  sha256 "952364766e645d4ddae30f9d6cc106fdb74d05afc4028066f75eeeb17c4b0247"

  bottle do
    cellar :any_skip_relocation
    sha256 "406f503777d7335cc815bfc4281a736aa0b93538ed3b52211f8ec819e85267da" => :el_capitan
    sha256 "25bbae994afdf3383fd2009881f09afb2adda58ae9f2803e43a1230fbd0eb19d" => :yosemite
    sha256 "1d7dfd2af3332f0048458ce250c1d98caefc7cb77718e74a0646ae233ee3e468" => :mavericks
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/".autocode/config.yml").write <<-EOS.undent
      name: test
      version: 0.1.0
      description: test description
      author:
        name: Test User
        email: test@example.com
        url: https://example.com
      copyright: 2015 Test
    EOS
    system bin/"autocode", "build"
  end
end
