require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-5.3.2.tgz"
  sha256 "189a1d168a21671f823b1618d21863db180a322bd122a21ab5ccaa2a0ebad604"

  bottle do
    cellar :any_skip_relocation
    sha256 "1396b26c965566b6ffbcc15e9ba1b4ef87d6adcce20368e179ebe5d68f35d339" => :mojave
    sha256 "481d40b1e94bad8a808c32a910cd4207667448387c04878c6e37df18d3c1055e" => :high_sierra
    sha256 "ab1c7cbd32901ef3af41f77980f0e57584176e6f0eeb74d4e7b02150905a93ea" => :sierra
    sha256 "bf2cd3efff3eee72713582f5cf72de69b8e574f1a98827b9e8370486005b8831" => :el_capitan
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
