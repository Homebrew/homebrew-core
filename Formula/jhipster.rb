require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular applications"
  homepage "https://jhipster.github.io/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-4.10.1.tgz"
  sha256 "52f0f6d9644f009c00844c1a498f84bb8154aeaf90a2be7558cb6b9e3f843d8a"

  bottle do
    cellar :any_skip_relocation
    sha256 "9e8a5f8443774013069f8ff1ce1a2bb5cd2a660c01488bf2f3ca623ea3d7da4e" => :high_sierra
    sha256 "c64d47c9d5dc308c1b4a8f9198fbd90ece8cf2c92e1a0924e20b478db43c1888" => :sierra
    sha256 "e3016d70a935688b806ee0ba8d7d2858b054efa8e919e7f0bc0f90ffe74c3b4c" => :el_capitan
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
