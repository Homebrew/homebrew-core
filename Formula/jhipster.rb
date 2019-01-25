require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-5.8.0.tgz"
  sha256 "6160511013a421ce6cc5e47b9c492cc7e1c9a116c2a9b3221ea5872da8e6d0af"

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
