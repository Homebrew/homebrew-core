require "language/node"

class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-9.8.4.tgz"
  sha256 "d888e44d3df6c82d49d3555d7491bb2e6cff706c61fbfd2da813174bd3ba08e8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4f414d40874e0430c5c59d0fcbd94f0db1a814a16095ced98137137640ac7746"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c815822b119291d2a3b88b6fd4f741ae06de4044f71e68f34be5a315e1aecaa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "442e5216bda0a6bf3024989ace4ad6bc35246ba80f788d02303fd047efce6414"
    sha256 cellar: :any_skip_relocation, sonoma:         "c75504c79f7a52be3113561ced0d60e388413c76e29024db65e3595735e91dd0"
    sha256 cellar: :any_skip_relocation, ventura:        "e640e19ba1dc0dc370ec27754b93381678a4862df0cc60ce54ac186b54936e8d"
    sha256 cellar: :any_skip_relocation, monterey:       "9c0cb3a8657404169513cc93a6e26d697f3edaf04168f114f22ba9900461edc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b35f9fb5f846244982760721256e5f49b6b29685b9c4e1a23becc02a794952f"
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
