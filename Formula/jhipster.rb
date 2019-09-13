require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-6.3.0.tgz"
  sha256 "cfeaa90e1f4e1d37106d46c9d65ea7db0d7ecbaac26173c0bc6fccdce886d07d"

  bottle do
    cellar :any_skip_relocation
    sha256 "a2f25ba7fca678f0097fbee0d8e643b3ffe37fcb96f0c5e06833efcd9b65000c" => :mojave
    sha256 "10d0cf5fe48adaf916530547884a38021673461f66327ab209dc68ea449f10f5" => :high_sierra
    sha256 "27094de5395534f7ad6cafd3fc8be5044252e8ec7fc3445a4e7795c4c3e22f25" => :sierra
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
