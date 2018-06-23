require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular applications"
  homepage "https://jhipster.github.io/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-5.0.0.tgz"
  sha256 "79053caa86ca7439ed9cfd084af17173099ac92d98669a1b10d4b0a5b7c59a86"

  bottle do
    cellar :any_skip_relocation
    sha256 "4f5bce87bc2c45ad6b0365ef5410f4d0836991b2e63c4dcba71a0bf2a86bed11" => :high_sierra
    sha256 "c6de3a07e784a9a9fb61dd97ed83fd9c6dcc685bc5341e27f963437aa45e2e2b" => :sierra
    sha256 "bdcf90a806824d42d8ccad76baa6ef4816f09e5ff1f59c5a6659cb4dbe634d96" => :el_capitan
  end

  depends_on "node"
  depends_on "yarn"
  depends_on :java => "1.8+"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "execution is complete", shell_output("#{bin}/jhipster info")
  end
end
