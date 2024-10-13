class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-10.10.4.tgz"
  sha256 "a23eb5a4d6798b451896b2b40be3d1450fdad07d44f9721152f042d09302d0de"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3e06b26e9046bdb4840ab2acf32922e1c8b9b93105b7ff3316c1a9d8ef4ecf9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d27f0048d82cff1f50fe87d789e431f7d4271c42975e1fc85225310ac63b34d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ab1b34a650fb37aeb93cee742059f24e6f436c80d62748c3fcb656c92a0b0637"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f90fffcf3a70f9be23de38dd4108a3abf7f75497b0b8601adcd33d43c1f8605"
    sha256 cellar: :any_skip_relocation, ventura:       "84735f932cc1758ba6f3f49ec87cff60634288ec10dc6118b65ba081d62d1c56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2e565084e81dec36cddc4174034902fe72df0bbfe86d043aac0620322399f32"
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
