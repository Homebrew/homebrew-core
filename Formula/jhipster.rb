require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular applications"
  homepage "https://jhipster.github.io/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-4.14.0.tgz"
  sha256 "c7cec8c46c1df36fe3b8ed7b5ec7851f68f6ef6108a72d62aae8a3212cdd13dd"

  bottle do
    cellar :any_skip_relocation
    sha256 "18ca023b7f062c2ba2edd0c8fdff480c2fc2deb8aa346a8da41e672baa409c2d" => :high_sierra
    sha256 "e7b863fe1915417f275db7907baf410b6d2a68e4f1bc58274c6902043359ad87" => :sierra
    sha256 "fc6d13a469f8a19d86bce0ccee2b5b30d44cda085adebafb2a8a4433c8bceac8" => :el_capitan
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
