require "language/node"

class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-10.6.2.tgz"
  sha256 "bd5fde1ac5b6b1a2a9d3771e87da796da252be78dee10d383c24c166899b4f01"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc6273c3c40dd3cf8a9a808d5bb5c0a58d3b8e27dd71a79dda6311f0904afb1f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5036e210c0a903cbc94f4c96846209972b70a36364e15242fa5a9b516bc9a808"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a287ff0abf225365d2ef84c6625112129933ad2423fb08c97cfae3c6b6b52efd"
    sha256 cellar: :any_skip_relocation, sonoma:         "ab744458c1cf9cbb259a117b5ef0d2775daf06e323d8c911142601ad828fef30"
    sha256 cellar: :any_skip_relocation, ventura:        "755a7e3670c856b5767d694e7022b44bd4827aadf008053d2036da611d61603d"
    sha256 cellar: :any_skip_relocation, monterey:       "b0451e3c9cbf798fa352e95dc778db8a53a367f8fd7af072f6fb3dd7d1d35c9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0843ba99ed72395d491c6dcb3309c78d9c885509d7027239a4db5788aafe101"
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
