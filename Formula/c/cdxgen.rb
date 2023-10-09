require "language/node"

class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-9.8.7.tgz"
  sha256 "92d72b045eefcb7dc9e3dbdb83d1e1fb27b104875883d9d785a77f1c1af57559"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4478901e00f6bea653477eebae0c444d0fd132c598ea4935b6986e0efa582f8f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac95a4d02331f3edc6faa79cf186942a72251bd7790ee4e0fe0849fe568030da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49ff32079e6d5812b1598f01d0b99b39198df0aee217749afa162d1f1218dd48"
    sha256 cellar: :any_skip_relocation, sonoma:         "91811b437c94e8d303bd4d243cbfad93f69d5df55e87930ab1678aa238e79e5e"
    sha256 cellar: :any_skip_relocation, ventura:        "e6fbec82366ee9e08e561c0c88512e9977aba8bd63f83099d6694b5016269105"
    sha256 cellar: :any_skip_relocation, monterey:       "01a37eaa6a134ad962b898d78d92a551ddb2d21e0af7175e380cf3d2b0d580c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "733ec4853d7266062461a57eb20236bb20727314b4830f71b36a6237bf9348c9"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@cyclonedx/cdxgen/node_modules"
    cdxgen_plugins = node_modules/"@cyclonedx/cdxgen-plugins-bin/plugins"
    cdxgen_plugins.glob("*/*").each do |f|
      next if f.basename.to_s.end_with?("-#{os}-#{arch}")

      rm f
    end
  end

  test do
    (testpath/"Gemfile.lock").write <<~EOS
      GEM
        remote: https://rubygems.org/
        specs:
          hello (0.0.1)
      PLATFORMS
        arm64-darwin-22
      DEPENDENCIES
        hello
      BUNDLED WITH
        2.4.12
    EOS

    assert_match "BOM includes 1 components and 0 dependencies", shell_output("#{bin}/cdxgen -p")

    assert_match version.to_s, shell_output("#{bin}/cdxgen --version")
  end
end
