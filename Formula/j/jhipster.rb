require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-8.4.0.tgz"
  sha256 "5d9ddde6054c9b2c4a55907886fb97c1504b9370679ae00e59f5321c265b967c"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_sonoma:   "286bc10588a65bb1f29e44872b7714290e71a633008372d75f6821d590a7b7bd"
    sha256                               arm64_ventura:  "64ce9ad6819608587532354fc0377db34cb5128221fb807b2ca4e7b08843450b"
    sha256                               arm64_monterey: "54260f8bd641e5204e270c31f3d47b331c1d02fbf4c8e10e4c0c0d834595abb4"
    sha256                               sonoma:         "87996ac6099dda7c51af8bc9587c958375f6c19a8ac12b9620bd67a4c389094a"
    sha256                               ventura:        "cb8379de68cd2ec31d83cf7c520652954755b2fcc59c79fb66777e4e3728b456"
    sha256                               monterey:       "f3441f4aa20beecb1e0ec53f7dfb413d1675bf7291a99f0fbe1211d80bdb5fc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "811b50a54d91efbe169c6679d35d23bfab615df65177da374ca5f2d33e970cb1"
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
