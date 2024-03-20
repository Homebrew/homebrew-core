require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-8.2.1.tgz"
  sha256 "07cccb9fd08dc752158056ddc5c8b2122eb17d004421495ea44f39b8eef7a2b8"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_sonoma:   "0e17bad03f85df6836fc6df3511358255d53e5dfe0bf078e51b0b7894585b8a4"
    sha256                               arm64_ventura:  "a4422cb587db92fd53854d205285c1b16031a7977e20f1dc68ef8543a6eeb838"
    sha256                               arm64_monterey: "85d8aba14f7da7f8e463c3e9abc5549a04e50275df0f04a8dd4cb62431519cf6"
    sha256                               sonoma:         "e672aaa5fd475aaee9475c841ae271cdabbafda452075cd51c1cf20d34efcc8b"
    sha256                               ventura:        "d17984363c0dc7aad3f0f3bd506a3c6ded40540409524a8fe7b5f12acaed7b87"
    sha256                               monterey:       "d2fe7b05f711a499e8b7c983ecddbf8ea8a446338e7548ebc6b1c8aa300a095c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6fd2d70e939bf83f778b210210c56e6e259f20104d2f6e098d8986c1b91dd202"
  end

  depends_on "node"
  depends_on "openjdk"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/generator-jhipster/node_modules"
    (node_modules/"nice-napi/prebuilds").each_child { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    output = shell_output("#{bin}/jhipster info 2>&1")
    assert_match "JHipster configuration not found", output
    assert_match "execution is complete", output

    assert_match version.to_s, shell_output("#{bin}/jhipster --version")
  end
end
