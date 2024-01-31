require "language/node"

class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-10.0.2.tgz"
  sha256 "2572e8aa8e8317c12b447f44fec399eba59d85886096d5ccc9f57d05dcb77119"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d386b20658ce30403174be19f3ea7a1f9426eed814ed8a5ffe716ef4a8f066f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6221e36388f1bf7218cab3ec0a96016873a4e9ee26dac79d331805ab9975b5c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4208b279d5a8149bbd9552818f7d0fc9e0c1dcc57c4e551ca781b7930de08d1"
    sha256 cellar: :any_skip_relocation, sonoma:         "bdde488220a0e6988286fa908b93094d4bb027493e5dc212245fc6da9b30a42f"
    sha256 cellar: :any_skip_relocation, ventura:        "28ade729e542e5cc37e59ed397a528928ba7cd004a94f1e2b5e88bd771724f82"
    sha256 cellar: :any_skip_relocation, monterey:       "224009fc104cc3a1cb29e3df713d6f4276183bea9d2fbc687d819cf32b8ec234"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9bd804e09e4f5321f79bcfd29c9d6af9cae1445c794b43f0c0e21d3c277cef3"
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

    # remove universal binaries for OSX Intel platforms
    (node_modules/"@cyclonedx/cdxgen-plugins-bin/plugins/osquery").rmtree if OS.mac? && Hardware::CPU.intel?
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
