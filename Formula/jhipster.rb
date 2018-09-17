require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-5.3.4.tgz"
  sha256 "91dba6dec5fb2c39bf2fbcc19f3979574e9bca3c2944cd051162d7587f217a2e"

  bottle do
    cellar :any_skip_relocation
    sha256 "dbff108193333969fe83f86ebec3c1277ed78538daec74802f416e8149e86d91" => :mojave
    sha256 "220c640434a2af005c3c0e0fb63606a0a0df02910bd24e1bf71d3b2d15f0f78a" => :high_sierra
    sha256 "123a6fb28a9d878e49b51024a1b45150a32678c310318e372f3385642a867214" => :sierra
    sha256 "d3327a74760344701cd582e82a5307389627da040c68235aa05962013727e9ca" => :el_capitan
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
