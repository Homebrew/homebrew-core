require "language/node"

class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-9.9.1.tgz"
  sha256 "f9a15b725dc3cb653224ad256bbe5ad5b59b7c71ba81aca13527199fefeab848"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5a864e6b2ceed59b5aeaa414683c0249d8f57e3f28ee024184a1a865cd1a32f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "44446d58149fcfe24c3e875df8733213c4a817bebbb69f29f86d8ab42372458c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8457f22b20fad9a36e96f8d0aa37900c48eae09cacdd8300e8ddbd0b703960a2"
    sha256 cellar: :any_skip_relocation, sonoma:         "c47685201383d0b481bbfadf4b68cccb0a74d6bda99ea190630e51d2193c0b20"
    sha256 cellar: :any_skip_relocation, ventura:        "8856aa0cd262c16f94fe368b8781890cd840a06abc8df5ab0d2c87eb7e68e9e5"
    sha256 cellar: :any_skip_relocation, monterey:       "44719fe2da1d8c966353e17ba95e0f23fe2fac46a671bb52a62e66de3f5e1c01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "398de52a9c33bb23ebb4d85461535d5d085520744e1317a22623c64585792cf8"
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
