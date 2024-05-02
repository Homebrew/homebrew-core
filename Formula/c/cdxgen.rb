require "language/node"

class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-10.5.0.tgz"
  sha256 "f50ae387d0f34ebf3dc88b53f49c63ab6fba1a4fd0fb2f1a3a81c04e5c96385a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d5f13230564d6adca837264b24bcc85d550cc28b71c10e759fe014a90d8024e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "16c35f4e8b17fb17f0817736646a48f337e713483b463c022df50c7d59dd0236"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d820bd5a7b04c35dea23c1a04e46a1c0916a9da58afee9040e726adf4f54ca7"
    sha256 cellar: :any_skip_relocation, sonoma:         "40cd8d8bfb16ac1752c17068f7cc943479deb44b77554d1928fdcf5d9a02bf73"
    sha256 cellar: :any_skip_relocation, ventura:        "6112725e30c9dcef5340ee81265b95a914740fd78f1e0c250fdda390f40e7768"
    sha256 cellar: :any_skip_relocation, monterey:       "50aa82dab499d8678473a037be287e2d9c835dad1e792bb30669de98dedcd1f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a7923f3915971ec3f35358d2245d8dd0218da95b103e8aa82468b1c06b59d1d"
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

    # remove pre-built osquery plugin for macos intel builds
    osquery_plugin = node_modules/"@cyclonedx/cdxgen-plugins-bin-darwin-amd64/plugins/osquery"
    osquery_plugin.rmtree if OS.mac? && Hardware::CPU.intel?
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

    assert_match "BOM includes 1 components and 2 dependencies", shell_output("#{bin}/cdxgen -p")

    assert_match version.to_s, shell_output("#{bin}/cdxgen --version")
  end
end
