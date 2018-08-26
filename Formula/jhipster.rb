require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-5.2.1.tgz"
  sha256 "f783a5e35c60b9a332ef7a263dcb67e8f70da7b3b526764932bbf2c39c546f40"

  bottle do
    cellar :any_skip_relocation
    sha256 "0aa519f7c582cc4f4a1bf240f6d475e8d1ce49b766083dc6cad0c7c31db326a0" => :mojave
    sha256 "c9480b34d4f5df598113504fcae922b788d11f5d49251e851eac34351d701f2c" => :high_sierra
    sha256 "86fbdce7ae298e4c21a68079bd85f278f151509414cc0455a352c58ce378a992" => :sierra
    sha256 "c0040c782683a5bfec8bb9e076dc903477fd99fa17e8d62cbfbecbf773028613" => :el_capitan
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
