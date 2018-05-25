require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular applications"
  homepage "https://jhipster.github.io/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-4.14.4.tgz"
  sha256 "e1eaecc3123cfc0b993a51e38731f25f0ed8d15f3d815419eb065f23364ccd69"

  bottle do
    cellar :any_skip_relocation
    sha256 "2c62adab1fdbc3017aa5000ae97b083c43398ebcedead451a28eba5c05b752bd" => :high_sierra
    sha256 "2ff8d915ca3fd8187ae84805edf99ad8247ac9c2f9698874eb0c5e244991535f" => :sierra
    sha256 "a08fa5eb9cce9f269dc1d0cf60bcda90ed745861a22362739ee8e17255f32d5d" => :el_capitan
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
