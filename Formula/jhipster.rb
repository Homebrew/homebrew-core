require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-5.3.1.tgz"
  sha256 "04c94ba781faaac2d60d06dfe869c870e325ba6b28084e3bacaa271beba74369"

  bottle do
    cellar :any_skip_relocation
    sha256 "ce15f31f730f51c876ab8b4b4d190349872062bf4760bcf5538dad1a234c5a68" => :mojave
    sha256 "8e7d57d9fcca0c5c9afdee0ca12c0d7656bef06612aba752e0a2f2173e092c75" => :high_sierra
    sha256 "c01930f7a252d6e526cd33fcbc4dab0fdf1f03fc719af10ecf7739f64eb110b3" => :sierra
    sha256 "2fe4c84b19bff56d08d94322fe43357a9dd9c229ee61bdac11d62ad6185ca673" => :el_capitan
  end

  depends_on "node"
  depends_on :java => "1.8+"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "execution is complete", shell_output("#{bin}/jhipster info")
  end
end
