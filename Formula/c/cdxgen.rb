require "language/node"

class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-10.2.2.tgz"
  sha256 "d6423b6c296ad933067b867f6fa8ad8b158c1cf29db9971a1edfe88aec5f479f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "70bb611e9cd90cda2d228193137eeeab080bb1e015837a88f546d97ad357523f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "52639cd923afc67fdcd96824c1c0f30eb34b9a1f27e3e9dd88c19e2935643fc9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b32c17d8867b08b0b4492b52403592aa00649e0ed82a2e5980ebc22ea155408"
    sha256 cellar: :any_skip_relocation, sonoma:         "e3c5fde1d5e9f91495639939d37849820aa935f30a647f192f3836db910f5a2f"
    sha256 cellar: :any_skip_relocation, ventura:        "21b12c5ae649fa785d76c4d6e69d4a25dbf721ee09ec34ee7c1550f0782f3ad2"
    sha256 cellar: :any_skip_relocation, monterey:       "2e2f6eb1b7527913db4fc5f1ef9274e1f7f28f3ae47c5ee5c277db71ff8f6ee9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8fd2f605621452316ce33e53e55e1603e3cbfbe8ddfe01af27bb7acbfd6e171"
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
