class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-11.2.3.tgz"
  sha256 "78369fccaa389210a37e8e672f0c9d0930611efefb60459be0a56ea54b6bfdd6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf5cf693fbb9bea3d5e5b2152a7c1992f777c56e3d105e064b98f4f521e73910"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0acd6cae3ec4d9d84757291444177feea095accca3a0f9dea58671cfd9a4243a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d507bdc2e1a1abaa3021d88a1e9df3a1712daeb22d15dd46a2f231a3c84f13f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "22b892b3a44786dc7de5c301ab9840b5e18817a1e260339f2924732da48af98f"
    sha256 cellar: :any_skip_relocation, ventura:       "5bbe082f8c4eb8e8f4dee1bffa0835a14aa50b7598f84599663f59bac00a19fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a70aae36079f0b984b065365b55dc52cc3fd409fb84fce0c016c161a80b7d0d"
  end

  depends_on "node"

  uses_from_macos "ruby"
  uses_from_macos "swift"

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
