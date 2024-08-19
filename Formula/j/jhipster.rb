class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-8.6.0.tgz"
  sha256 "bf5f4013a912df79979eb5d2bd69f809a16ef147a563a9985ced0eccb9333572"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256                               arm64_sonoma:   "02aa2afa323f937d58e16431cf3c2dcae78c7bcfb260858b5c4241e4fa22939a"
    sha256                               arm64_ventura:  "63efb46c10cced592b9799f9634c90b05b7ed7bb8548e06ec8ca1770c31e5d3e"
    sha256                               arm64_monterey: "f4ae8fdfb8dccb8e5451d7211e7570a433d1dcdfc5fdce832b985c0b2f99240e"
    sha256                               sonoma:         "9606e5c099b91c49b82fd1a0bc64c685d97db9514bf844d88f56eb2653213684"
    sha256                               ventura:        "71f9970b1625b53dc0e122f6bab113b5a273b5b059337b865eefd8fcd830ccb6"
    sha256                               monterey:       "117629eb5ef8c4f5baf3de5faeaf3e71d6aaa8ea9d93778f5f87fd71d5446137"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd2372641f1e1a7de33fc2275047d12e5c41704d4867cc95cf2142f840e887d2"
  end

  depends_on "node"
  depends_on "openjdk"

  def install
    system "npm", "install", *std_npm_args
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/generator-jhipster/node_modules"
    (node_modules/"nice-napi/prebuilds").each_child { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    output = shell_output("#{bin}/jhipster info 2>&1")
    assert_match "JHipster configuration not found", output
    assert_match "execution is complete", output

    assert_match version.to_s, shell_output("#{bin}/jhipster --version")
  end
end
