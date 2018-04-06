require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular applications"
  homepage "https://jhipster.github.io/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-4.14.2.tgz"
  sha256 "d58c950d25189ba42ae71c14496259e62c99ea7666f2e8c1de035668961927bf"

  bottle do
    cellar :any_skip_relocation
    sha256 "34491f7ccbb273586d6970b43e80bfbfce103111f0b3c6ac9312392c3ba45bc4" => :high_sierra
    sha256 "a9ff3540b980f1cc818ff29db3f6170d0e3c558a58abe9225f9ff3ebfc1a6f63" => :sierra
    sha256 "5461187c06e73c1aee5d75fa56e5512d23405fcd56eeaa9f38317d9a66a4fc92" => :el_capitan
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
