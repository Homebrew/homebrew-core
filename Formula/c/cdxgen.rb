require "language/node"

class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-9.10.1.tgz"
  sha256 "72814c55ffe5e227699450f6823a134d086261efc537fe69e2744dbc0cb72840"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "56e1049cf5ecf8b23da99a85138d16c9649cb4219d01081748ab81578e3ad483"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fb248ca6d437698fa51f467a6c840a2279ae7edc34907be539bbdaf81c4f1cba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17bad4d74af6d94ea330de8a54a3a2bf212dc93ac665856988ef5d658b468050"
    sha256 cellar: :any_skip_relocation, sonoma:         "a0b399b277b36f111ce201981d4ad366fee803a1328a20c4e6d81c89fbefce6b"
    sha256 cellar: :any_skip_relocation, ventura:        "53aa47a5bd91ccf05fbb02477c6e0046d70b1b7680c611a757346768f2de7117"
    sha256 cellar: :any_skip_relocation, monterey:       "912bcb374cb4b78444e0c2d88e10a6070bac56da89337741652e98b24aff39cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98c76fed5340d3cb395ca9a02d786216ceae675459d97cbc2ed62b43378c3e56"
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
