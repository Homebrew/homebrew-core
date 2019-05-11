require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-6.0.1.tgz"
  sha256 "a1f8d9d91fbc77f46209b5023f41a50fccf3bb31d7de3d3d4ae8ca667530bd21"

  bottle do
    cellar :any_skip_relocation
    sha256 "f858d17b0122f8bf26697940b2faecdaf01bf16f938080b85d83b83c600fb1c3" => :mojave
    sha256 "b78918e8ad154c54dc3d69fcded024bdf9008093ebd98a7a73adc5e9b9fc5a77" => :high_sierra
    sha256 "480f30288cd1400a8b7a289431e3f47b1297efa9a0d940fc04416ee5bd345b71" => :sierra
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
