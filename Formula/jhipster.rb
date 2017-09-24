require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular applications"
  homepage "https://jhipster.github.io/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-4.8.2.tgz"
  sha256 "b07ba36a7e6ff3b79a49a57bf3305cdf7db9cd2848c29160d0540a95352fccd3"

  bottle do
    cellar :any_skip_relocation
    sha256 "9835fb4f4f67feb21764a379054939f0a35857188e102cf5d68bd5c0b3610e55" => :high_sierra
    sha256 "046f8e47de8856d9236258a067df642d9f2b5cf485354edaf0a7c4ccec490e96" => :sierra
    sha256 "60f11205c80af3013a1f7fcb466ce0055354f61ff7d83033c14a70dba50b31a4" => :el_capitan
  end

  depends_on "node"
  depends_on "yarn"
  depends_on :java => "1.8+"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Execution complete", shell_output("#{bin}/jhipster info")
  end
end
