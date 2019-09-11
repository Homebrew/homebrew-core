require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-6.2.0.tgz"
  sha256 "cf1f83862130386f47cc7a11ef5e332abd58e7e7e7cf780bcfc01bfac3b60035"

  bottle do
    cellar :any_skip_relocation
    sha256 "340d6d9d8f1a34fe9a07e8f33b3dd4ecfb274f6eddd45bac1e0f78a182c65881" => :mojave
    sha256 "20348a0a98e87751ead0c9359afbdeddd8f9bae8ebe29393ab8afb50e206bd72" => :high_sierra
    sha256 "54736305b2b8cb0d3d14a3daec676729f2c220f5449cac2957fead2bcf6bc3ab" => :sierra
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
