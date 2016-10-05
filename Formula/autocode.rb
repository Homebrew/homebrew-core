require "language/node"

class Autocode < Formula
  desc "Code automation for every language, library and framework"
  homepage "https://autocode.run"
  url "https://registry.npmjs.org/autocode/-/autocode-1.3.1.tgz"
  sha256 "952364766e645d4ddae30f9d6cc106fdb74d05afc4028066f75eeeb17c4b0247"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "f369819b2f33327071a68455a14f66855286c7614977f06704f21c38e2df5f89" => :sierra
    sha256 "c321c73e1662332392c5949467c544e18db30849019555086ad14eeb097656d2" => :el_capitan
    sha256 "a0b7c969db9e2870e818587c7d832bbe0bb187cbc01346b85bb81a6097a9e015" => :yosemite
    sha256 "04effb5aecdd48e2a3c38435079424fd83f08dff206096f9807ff7c4ccd68b93" => :mavericks
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
