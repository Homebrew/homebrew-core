require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  # Check if this can be switched to the newest `node` at version bump
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-7.3.1.tgz"
  sha256 "7a8efbf2b5fd03443215462de9018b7cf631457b59efd062dd0ff0d38dc568f1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "904c6594ec6783d3b78ed4ea1775f0cb9bad743290acb815e08abcf40b521622"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "53e333dbadebe5daabf052724857d1de9592480951d7b0fb0f1b62c6bbd7c78d"
    sha256 cellar: :any_skip_relocation, monterey:       "8a4958081d729f08fe8b55b09a58f22b8f1693e74e2ec6053aac5ebf86b60f16"
    sha256 cellar: :any_skip_relocation, big_sur:        "943375ab2c62e4a975d982fcc7a75d7922c878b481f204f1647f22835223e07c"
    sha256 cellar: :any_skip_relocation, catalina:       "943375ab2c62e4a975d982fcc7a75d7922c878b481f204f1647f22835223e07c"
    sha256 cellar: :any_skip_relocation, mojave:         "943375ab2c62e4a975d982fcc7a75d7922c878b481f204f1647f22835223e07c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0401856fe3b91a344b63010743be0b017ed187fb0bc6baade7d1a838951f756d"
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
