require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-8.2.0.tgz"
  sha256 "302a8810d08bfbb0891e899a5bc7e18f42abd55bb4c18199671e472fdd756f10"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2dc8c990aedb28f87ab039074be5e6ecba53c19a48e0649321fdfac2c13d43ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2dc8c990aedb28f87ab039074be5e6ecba53c19a48e0649321fdfac2c13d43ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2dc8c990aedb28f87ab039074be5e6ecba53c19a48e0649321fdfac2c13d43ff"
    sha256 cellar: :any_skip_relocation, sonoma:         "7e80b922dfabf30bc97f9f0b2651d26b4f4ab44194cd6c153ba7d0b0b8825043"
    sha256 cellar: :any_skip_relocation, ventura:        "7e80b922dfabf30bc97f9f0b2651d26b4f4ab44194cd6c153ba7d0b0b8825043"
    sha256 cellar: :any_skip_relocation, monterey:       "7e80b922dfabf30bc97f9f0b2651d26b4f4ab44194cd6c153ba7d0b0b8825043"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73fd3367f875d3eb191dc62924134193e2f043beb6d2964bd6399ab729cbb3c5"
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
