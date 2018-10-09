require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-5.4.2.tgz"
  sha256 "b18434c7b9e1ac0dc9324b1caff1e3e3a0a1c42a804989e9c63f9dee563141f5"

  bottle do
    cellar :any_skip_relocation
    sha256 "e00f96acf34a8fef4b6f6d3dc7a92c2e415d58bef869947ab2880ebe1dcad15a" => :mojave
    sha256 "38e7e9f0b6be0c20a83d512c401e0350ff63ac46fd360e10fe5098953d8d5852" => :high_sierra
    sha256 "96e94e6b14cde53c823e629d4095c06d133e44b4c631fd89ac283808fb9409e5" => :sierra
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
