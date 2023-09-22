require "language/node"

class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-9.8.1.tgz"
  sha256 "75316120c6b25f1c94b57b301ee87a603b1a70438b14bafb023a85d380942193"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f5ad86d501296dfee518ab71d2bcef23bdc19022e7b39491deafc821007512c0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ea115a4280540ab5abbdbbca0e28d5c47035883473c84b9aa07f105185efc08"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7c85951d964a1f2953cb5023bacc8e301f94c3c7c30601afb324d8d5993b5ac4"
    sha256 cellar: :any_skip_relocation, ventura:        "8dbf2bccadc5aa455db6be1e52723bac84dfb2eb24c9e3ba34cb357fbac9f51c"
    sha256 cellar: :any_skip_relocation, monterey:       "982aa9b1405d06e109c9a33dd94cbd74a8f74126f29ffa72240f5d0703290b0a"
    sha256 cellar: :any_skip_relocation, big_sur:        "645be62d5c9c3393ea2cb7bf4b3c20fabd25e1536e2f37f82b4d2814dc8b74d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36592ab92d599156cd3e15510b96eb6fc1d3fbd065e3569dfc48ef8504f32aed"
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
