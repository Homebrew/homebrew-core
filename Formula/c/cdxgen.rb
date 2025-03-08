class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-11.2.1.tgz"
  sha256 "dddacdc2ca8ed2b0ede47fb7de64c699d4831fbe0b3e07dc2d23c928120aa711"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a88f92b188979823b9a4840cfc71797d35672f04acc5920880764d6322c34c2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87985773ae476c27cdcf4ca6292f4d89e66d4756b9260c8190f66c23d02a791f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8a8885eb7dc46036641069730868489b4accb2e06f0442eaa7a38ce2a1dce575"
    sha256 cellar: :any_skip_relocation, sonoma:        "8842f26c78a4100a629eb068ec47a148c3b46396ede0ab17f0889fd701e09ba0"
    sha256 cellar: :any_skip_relocation, ventura:       "852fe7b4d3ece805caaa00a22544b78602f517e6034c6e2e6db356c1d4b9f3d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6206e8414e3c3cf0c0ef551833a798d40847f3cfd30e41892df58fc6972b735c"
  end

  depends_on "node"

  uses_from_macos "ruby"

  def install
    system "npm", "install", *std_npm_args
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

    # Remove pre-built osquery plugins for macOS arm builds
    osquery_plugins = node_modules/"@cyclonedx/cdxgen-plugins-bin-darwin-arm64/plugins/osquery"
    rm_r(osquery_plugins) if OS.mac? && Hardware::CPU.arm?
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
