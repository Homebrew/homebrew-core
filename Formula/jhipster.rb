require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-5.8.2.tgz"
  sha256 "153bfaf4e778a3797a22704d6a2d7630a1b4741131bc72352bacd075c51fed24"

  bottle do
    cellar :any_skip_relocation
    sha256 "b6b825762f8c2fca4bf93bd5ff250cbbe0b1c30774ca90d9128a47595f2b9049" => :mojave
    sha256 "eed470613019026525142d32f5ac228c909dafc5ab3dae2ccce7abff6f5587d3" => :high_sierra
    sha256 "cba4b884da504ce15abaac2e692c59fa50068282d3e38ae5ec96756dafec0386" => :sierra
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
