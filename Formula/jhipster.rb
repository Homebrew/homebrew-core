require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular applications"
  homepage "https://jhipster.github.io/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-4.12.0.tgz"
  sha256 "1b418e384d76380278d451933434ea8d9bac3005770b6a136345c135013d819e"

  bottle do
    cellar :any_skip_relocation
    sha256 "c80760e7a2a6d0d2d5397d3706eef79f853c8917e8d3822fb7b9a0a1c252cbda" => :high_sierra
    sha256 "25b7da2e822e22b44385c9e44ce3bab3a069d0076053dd42bfa9e25315cb48b3" => :sierra
    sha256 "1f7e825a0e0a173d8c2125d368cd7dd77989d79412c3e35590ec9245a5d27322" => :el_capitan
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
