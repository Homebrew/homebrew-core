class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-8.8.0.tgz"
  sha256 "2636cccb29f9e9e2e62166ff7a6d4a720b4c4ed072a17e4636ae74bdd167a4d5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3a0bf87a412f2bac43e6f89802b5979ec081108f0f82e187a67b852af0cdf4e5"
    sha256 cellar: :any,                 arm64_sonoma:  "3a0bf87a412f2bac43e6f89802b5979ec081108f0f82e187a67b852af0cdf4e5"
    sha256 cellar: :any,                 arm64_ventura: "3a0bf87a412f2bac43e6f89802b5979ec081108f0f82e187a67b852af0cdf4e5"
    sha256 cellar: :any,                 sonoma:        "6ed7bc430493cc6d7ffff92f315c83c5cb8bc2ed576f3b7782f2ce51993c9ad2"
    sha256 cellar: :any,                 ventura:       "6ed7bc430493cc6d7ffff92f315c83c5cb8bc2ed576f3b7782f2ce51993c9ad2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e55cf6edfc5cc945d0276e4e6cacf15227921e1199ae849602702bfde03ee451"
  end

  depends_on "node"
  depends_on "openjdk"

  def install
    system "npm", "install", *std_npm_args
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env
  end

  test do
    output = shell_output("#{bin}/jhipster info 2>&1")
    assert_match "JHipster configuration not found", output
    assert_match "execution is complete", output

    assert_match version.to_s, shell_output("#{bin}/jhipster --version")
  end
end
