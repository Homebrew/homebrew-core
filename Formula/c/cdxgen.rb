require "language/node"

class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-10.2.5.tgz"
  sha256 "dd3db82e80a0386ee85acbd3c8fdc6c6e1c45c03afff720e07de5ab8e50732dd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8f60f3f835453e97e0955855b9cbb478a5efb3b8e0ee5dea83af3e9e1cf2d525"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "59fc48e5d5ca05dfa31fe653816951bfc71f46c1250e98e9eff5991f51b1126a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78c5ceb878b0804990d904d4fb61635ef529e80d57752aaddafc987dc3f3929b"
    sha256 cellar: :any_skip_relocation, sonoma:         "6147bf0eb1a17d72b840b120087809cd630f16f98e2e8d69104cea36329f6c73"
    sha256 cellar: :any_skip_relocation, ventura:        "56d67f0974b5a05c06ce0540cce9435bab38e9eaf500c38e21e5fe33e4e9368f"
    sha256 cellar: :any_skip_relocation, monterey:       "c2cdf7055b2d22ab14343a085e4ca999e4a739c6f02108aec0380940f078620d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "962482939835996c58eeffcd271f93e6928d001cc975e81a961156922e0d7e80"
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
