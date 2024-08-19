class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-10.9.5.tgz"
  sha256 "80aec90679cd81948040a4c35d54a7bcd1251990538bbed0044bde8cfa9fd683"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "18b3f1d3fbf65386193e75805586b1c97723412d56c4297a2107e0e6f98033d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "634dd86175254369f60d15a7a2af857b2e020af7037c0effcfe2523cf5525aca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2bf4967784e92fb04d4659edfd4bb85749d533e21b20df84e086632cb2c3e1a4"
    sha256 cellar: :any_skip_relocation, sonoma:         "b44b196ce47e1bbdd025ac73cf5b2dae89e34653afaf025db55ee7a869649e9c"
    sha256 cellar: :any_skip_relocation, ventura:        "6944aaf1c557ccf1fa15fdbcdfae4a4f5a3db9de98bf0b92fdc5e2ae45399459"
    sha256 cellar: :any_skip_relocation, monterey:       "c8ae63db0fe8281fc3508b7b4a9cfa3b0946ca8bee96a413a0b3c7445f7fa423"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95cd80ed1c7d287e5b705335fb2dd329aa473ca3ff1b182e89c8500884c1f28b"
  end

  depends_on "node"

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
