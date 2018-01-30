require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular applications"
  homepage "https://jhipster.github.io/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-4.14.0.tgz"
  sha256 "c7cec8c46c1df36fe3b8ed7b5ec7851f68f6ef6108a72d62aae8a3212cdd13dd"

  bottle do
    cellar :any_skip_relocation
    sha256 "91237d3d4501bed5f2ca8d6e5da6359f94838f93a87a878320d02ac76e8459a7" => :high_sierra
    sha256 "db631fe5f0b584005962226964be16d9ee6eb66fb30b985680ee067495dd659f" => :sierra
    sha256 "eadcf4e1484eeab675aff1cf52905fb16897bc2e9b22893cb6f1f215bcf1544c" => :el_capitan
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
