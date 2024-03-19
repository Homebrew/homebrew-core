require "language/node"

class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-10.2.4.tgz"
  sha256 "554f5b75f491cb4a04edee74c8390e6c36adb5a1b0250748d1737c473917bf2f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7492cc7aecf767d97acdde4cb7ca742c8965adf95e362240043146ae4b10c559"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9662c6db8f5a972603b6ecd9afa99dbb696b702386a09ae01c2d638af985cbb9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aaefa94a2efe519c1e12ff181c592b2013e17b6bb5ddd092c7175320673edb6d"
    sha256 cellar: :any_skip_relocation, sonoma:         "565e747f19356a5b00bbbc1030d677bbf24e5f5e726ad7b9d5ecbb1d2d5594f8"
    sha256 cellar: :any_skip_relocation, ventura:        "f59067ac562789e03f713ae023d4f3a8909d1e3d7642581c218ef8c2176c0dc7"
    sha256 cellar: :any_skip_relocation, monterey:       "5f9f204e3f5d3156ab65f06ec3f0a4729e2be88030a75ce14ba9efc9064a0ba1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5e92686187ef4d3c5e7702583c9730a914c4e66e2ecc4339c135ddcc4a5019c"
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
