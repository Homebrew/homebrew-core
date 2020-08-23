require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-6.10.1.tgz"
  sha256 "65304b03bb52f8a7501e4074475b386c8c6e57692e30c878f49335e1d1dd9afd"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "fdcadb5944ca4be17d94e7d1fbefea22aa7957458e3224e9ad72366004aac4f7" => :catalina
    sha256 "16cd02713525c612bec9231ae73a05a9390c6f520710847e14d00043ca5c0761" => :mojave
    sha256 "5631dcc3e065ad2e7b3df58534a89175688358c5482b7133f5410dc7ea11c353" => :high_sierra
  end

  depends_on "node"
  depends_on "openjdk"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files libexec/"bin", JAVA_HOME: "${JAVA_HOME:-#{Formula["openjdk"].opt_prefix}}"
  end

  test do
    assert_match "execution is complete", shell_output("#{bin}/jhipster info")
  end
end
