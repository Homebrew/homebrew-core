require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-8.5.0.tgz"
  sha256 "5c40bb3225142e9536a8262b4844470fa52e31cad580de6830f26a3cc5feee66"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_sonoma:   "0fedc5b030f9772fde504afb57a6139fc7587b6f39089055eec59209b1e6ceeb"
    sha256                               arm64_ventura:  "f858864dc4ec231a065ccf5a01cfd30b2452aca7016410041d42997f80419df2"
    sha256                               arm64_monterey: "856859fadecd6a1553ee66fbab4ecab649c90332d0c1d9bbe5554f21243a477a"
    sha256                               sonoma:         "c3427fca7cd4408e5c23064e8b6150a292abcacb16e5da79bffd3fd3f2c6b48c"
    sha256                               ventura:        "bcdc74c2567bfe85839989c580705b071a9b6dd6f0f3e78a5d883c729034d987"
    sha256                               monterey:       "deb31e428a2988d841b4e5823a6d6b9e7d8c9090e45bf1263c7a6b342fe1b2a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4883c97ceedc4fb8333f4740ceb1cb761982a9db3ecde2f52c6fc2be9d09903c"
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
