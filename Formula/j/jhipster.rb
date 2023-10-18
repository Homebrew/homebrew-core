require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-7.9.4.tgz"
  sha256 "6d24c81e0cb3218d42f7c39d2f95ed6870ac1deb99ce43a61f37d98046f9f8a2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1574ac40d09244c8d58bfe981cd80be9310b105609b9bcb8cf239bdda5807294"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "94c8be9ac8e7b6016531321ceb2be0c1626499d59a74f1195539917c594c32fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94c8be9ac8e7b6016531321ceb2be0c1626499d59a74f1195539917c594c32fb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "94c8be9ac8e7b6016531321ceb2be0c1626499d59a74f1195539917c594c32fb"
    sha256 cellar: :any_skip_relocation, sonoma:         "eee47f78245cccafee78f1810ba6a2a8640d0bab6184f698558907caee11510a"
    sha256 cellar: :any_skip_relocation, ventura:        "9cf8133bece2718e287b3c01ff6f068b07bc57ff56648e0e56fe724f3a93572f"
    sha256 cellar: :any_skip_relocation, monterey:       "9cf8133bece2718e287b3c01ff6f068b07bc57ff56648e0e56fe724f3a93572f"
    sha256 cellar: :any_skip_relocation, big_sur:        "9cf8133bece2718e287b3c01ff6f068b07bc57ff56648e0e56fe724f3a93572f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94c8be9ac8e7b6016531321ceb2be0c1626499d59a74f1195539917c594c32fb"
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
