require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  # Check if this can be switched to the newest `node` at version bump
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-7.3.1.tgz"
  sha256 "7a8efbf2b5fd03443215462de9018b7cf631457b59efd062dd0ff0d38dc568f1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "23480174aa3ca6b111c7467391a03c47de4eb81e1afb895859d6d9f8fd73780c"
    sha256 cellar: :any_skip_relocation, big_sur:       "8b8150fdb29447bfc341eecdb4420e55e363b20ba6d855d8dbe1ea196c0fe549"
    sha256 cellar: :any_skip_relocation, catalina:      "a3e23bd1bb8a5617d52658e66a957702f77366a19901f1a9ce3c5cb102eaa976"
    sha256 cellar: :any_skip_relocation, mojave:        "dc822516f9a30a7dc214c7b02502f4ebbbe2887892f81a9ac368c888d0724ac4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9a71d97817ac9dc2c5fa1ca16603df3e99923fc34b7b5fc96c3a684d1cfdb77"
  end

  depends_on "node"
  depends_on "openjdk"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env
  end

  test do
    assert_match "execution is complete", shell_output("#{bin}/jhipster info")
  end
end
