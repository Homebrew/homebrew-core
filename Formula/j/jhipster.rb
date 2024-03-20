require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-8.2.1.tgz"
  sha256 "07cccb9fd08dc752158056ddc5c8b2122eb17d004421495ea44f39b8eef7a2b8"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_sonoma:   "70a8b915144bed52549b3b8d265475550167adab38ffadf39870f0622c935dc3"
    sha256                               arm64_ventura:  "95fb0eaf5b8727c68201225355f4593cf6a04c0e0c61c480ffa0c949174fc1ec"
    sha256                               arm64_monterey: "6f9bd03bc4ded1f3d3fbd2618356c2adcdb372d93205136429356dcf1f012adb"
    sha256                               sonoma:         "2e991301109444007637ac76f5ad38106b827725884ba111a20a67b034d2d10c"
    sha256                               ventura:        "fec9456a62397f0194dce279b3018869aa1fc20f15cb296962e473e6b1264519"
    sha256                               monterey:       "5ac0561abb2de6b6a4f553bb8b85f42b0d6f02e94e286b7e90f4699c91128b77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59d247b45cbc414913eb5e84c2ac231a90cbb18f38984933fba2c44fcc30ff92"
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
