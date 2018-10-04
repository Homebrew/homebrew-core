require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-5.4.1.tgz"
  sha256 "ea97c06f4f6e85937a0879116f6e3c9add4907b639d774159004e49b23ff552d"

  bottle do
    cellar :any_skip_relocation
    sha256 "fe9321811afffede4f2f205c852094935ad35cfd29ae56516ceadd34d6f208ab" => :mojave
    sha256 "6f0cdf6b8a41185eec287e7e5e5c4eb53255fc5f0d0ff7d531b67d013ad1a888" => :high_sierra
    sha256 "f0ec34f94009d8420261c4403dd718ee69f6886de31c645edc47b808abf14450" => :sierra
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
