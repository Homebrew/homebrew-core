require "language/node"

class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-10.2.4.tgz"
  sha256 "554f5b75f491cb4a04edee74c8390e6c36adb5a1b0250748d1737c473917bf2f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "256870629a4b280564eb7af3e399450c68a97a3fe70d78b57c024e7015f6deb1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a39279a170b79e95ef719997b3ed76bd8f6ed34adee7837400fbdb0c6d11c60"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dad78ba9364ac4773d37da40be3b708174fb7f3a13a6eb5a9875f12f14954afa"
    sha256 cellar: :any_skip_relocation, sonoma:         "dfeedadc054ce9ad2f76874b422f31e0e0d3f4fa7561a470420a42c13031ea77"
    sha256 cellar: :any_skip_relocation, ventura:        "9f83ae5cd99d4e6361ca91285f14152abf1971c0f0dbd268510e3ee54ee3f9f8"
    sha256 cellar: :any_skip_relocation, monterey:       "ceb6ebc8028fe52839e708a30625263f9023016588ce48f0b87dca0a25911c5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0b43c80ebf3e127106fe4ea19e001aa983560aaec7aeca31f0e9e695d753f37"
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
