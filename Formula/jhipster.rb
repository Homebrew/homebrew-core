require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-5.7.2.tgz"
  sha256 "7ea68c3d328e762f2bf3a88ad4674bd25083247f7d4089673d84ede9d9d3e36b"

  bottle do
    cellar :any_skip_relocation
    sha256 "c3e974b7bc0a58eb824b346ffcac4ed9b5585ef379fe96ba7212e61e9e97d8ee" => :mojave
    sha256 "bcf8ca9617abd711c2d73ad8001540d5a0592d80e222550a9f823a85515e3ef8" => :high_sierra
    sha256 "5a1a33450048fbcba6cd9d1298ad5971cabb1669f002f78528d515e789f94550" => :sierra
  end

  depends_on :java => "1.8+"
  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "execution is complete", shell_output("#{bin}/jhipster info")
  end
end
