require "language/node"

class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-9.8.10.tgz"
  sha256 "49311abfe04fda69028404cdfde9198b3d4364e48280ed51746dc46ac2de377a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5a684cc402d658caccd470157d9302769a403c982a33d25e73a1fa25c1c62cb3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "98d79966e0bc1d5afd89be4f02e2826fceccbd23d97d30abc6423a2b0eb7f375"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d1ee54c921451ed4b3022cf368a8dd6d33d483910faee74e1e357d250a61e44"
    sha256 cellar: :any_skip_relocation, sonoma:         "a337b54cbc62ccf78ce9c47a1a69e85133f07f9e04e8bc52a0cc1098f241a0c4"
    sha256 cellar: :any_skip_relocation, ventura:        "db3e6713d544e18c90e37137c62a29285034506d54afa9822e4b9460a8f422dc"
    sha256 cellar: :any_skip_relocation, monterey:       "695b469be8aa1a887ce238cfaba5507073658d631367b18766b5cb6da1481571"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba7b92964f079bf09b31426f9eef379ccaf5ed40542c061522ee6c8ff34de6a3"
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
