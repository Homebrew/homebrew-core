require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-6.4.0.tgz"
  sha256 "59b47973e535ade24d98243688c6eb36b3d277c9b1a38c640749f47503fd38bd"

  bottle do
    cellar :any_skip_relocation
    sha256 "13118955f2c721eeda99a15405601dbab87a98c10b9fd1e7834cb8a4c5da9a8b" => :mojave
    sha256 "82e9921315917f8f4f62ed3d6f03f6144c978adb3c9c753d94d199615bba3678" => :high_sierra
    sha256 "6d2457123ab7977fbc3c2b52d958dd47302caa8ad5ad53651b6e3c298ea8ab1e" => :sierra
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
