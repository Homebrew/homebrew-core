require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-8.3.0.tgz"
  sha256 "0f4e0b2d6153826145a6f06987ea478a7b2fe63f245e47b07365f48cc25b76df"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_sonoma:   "9fb434833b28fd8f6ccee122b01f3e2dde6505c39fe2814da8918156d96ee145"
    sha256                               arm64_ventura:  "69b4657bd15ab89f707c682aa5b0349a17ab3e5a6ae28fc0788440ea471535cc"
    sha256                               arm64_monterey: "e585c6ab8ad5b71de9610ca257c1d920ee26564d7227c2d83203bbbaf6b6c957"
    sha256                               sonoma:         "024039e03a8111589e8ca245edcbcc184485326867fdb2324a5790d0206ebd32"
    sha256                               ventura:        "0207611b8a8f5190a4d06c01121741d89f697ba77fd0f31439a6af66033456ba"
    sha256                               monterey:       "b39ee692cd47f4181371ebe56de1764e47e844fad1ff5519365f0ad89ee1c6ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e7fe58e0b9325d21812460001579feb827654d55429d3532b25f599e5fa0028"
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
