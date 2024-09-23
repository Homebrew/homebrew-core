class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-10.10.0.tgz"
  sha256 "c0ddc1c737309b8201dda9843d74949fbda4f57ce847989a58d57112a273e12b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3cec723fdb14fa5eaed6f5d89bb4986d84502a6295726372216589b8f89173c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06c21fcb2c6b5dac23ec689575a8ab52ed0801376e0316b0505a8a77a080c23d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c370877c9b5c78ad10e77460ec71612019a52cc87dbd43d42dcf867e44a8a53b"
    sha256 cellar: :any_skip_relocation, sonoma:        "4866d44927661a7dc8949fd4fd35ed0042ba5ae45e4ec3db2e1dbc51294c3999"
    sha256 cellar: :any_skip_relocation, ventura:       "ed5af65385760555c8892e7fc7a92e9eafe3b80bc8c5ff442e98942090d97ed2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "380bbd22f05f79578ed4cfb46eb73a1b672e2ec6f62855eef38066d17471a238"
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
