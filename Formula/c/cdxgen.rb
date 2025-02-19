class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-11.1.9.tgz"
  sha256 "69b83260fe26c68e1c4a8703d5cc35836c8e77a32d6bd5c4d080f340645c71a9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c76177de3e52de2bc75e5501884cf4280f101e8f5809c0a9ce4650eec6af089"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e0004849c011e6cfc6417d7c814ebd103d089faa2a753931539a862d285aa8d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dc333ef851716816b307384074e3f036a9cbab95e3b4b61e402304cdbc31344e"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0c2880e9cbd50764fe3a47771530181ffe989d761f1140f5a80e3fe5cd25e45"
    sha256 cellar: :any_skip_relocation, ventura:       "1d84845eaeef1b8edfecf1e033782dcccf0a3ae3a14bd3bdf89d879c9c0921d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e91cc5b70b7cf69bfdee6f9f5bc3fb1ca72fcd7a9bcff6fbae8a0e290e91212f"
  end

  depends_on "node"

  uses_from_macos "ruby"

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

    # Remove pre-built osquery plugins for macOS arm builds
    osquery_plugins = node_modules/"@cyclonedx/cdxgen-plugins-bin-darwin-arm64/plugins/osquery"
    rm_r(osquery_plugins) if OS.mac? && Hardware::CPU.arm?
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
