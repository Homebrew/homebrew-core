require "language/node"

class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-10.5.1.tgz"
  sha256 "e902c9d02539818454287101e607f788c4b90e649b902334ef05fbfb77bf6923"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "09810de5c6e3d7460bf5265bea2b7535dc9e2126f6a4c77baaa26f0ddc95f6e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "390b9401f04b82ad208488caccdde284f260aa3673ba69fc9a78704cd42c5eb1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aac6ff6706d721cd15d935cc6d2aa48d186966af1be8f8baa57535c4036b1968"
    sha256 cellar: :any_skip_relocation, sonoma:         "e0aebcdc4108fce433d7a01a6d4c1cffdb67262434361bc92f350d96e03fb294"
    sha256 cellar: :any_skip_relocation, ventura:        "2ec3b15f0d1bfc87f88962d23a99b4a006e2900532a12aefae5836bf396ad4c4"
    sha256 cellar: :any_skip_relocation, monterey:       "6c259cc50be2e4d71a12d2cb1e04eea7b197c8b8b31d8e40363fa67011e95cc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de98888d765f12e5af3e8efac56a8126d24f2acdea640af7082af39bf04184ad"
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
