class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-11.1.1.tgz"
  sha256 "4eb9ef6a1234f8d7cf3aed9fc27abbbe36028f6b2faa2f200ada708b8696b0d1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed0656b6686cc588b9d5b3267114606a9b357d3c95cead487bf10770fd7ffb5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4616474678ba0d092590b51ede5de7d86325e049cd3c5311b6c6d4815a8ebe5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b810e0bd20b3d1920e21063d774125857c495a2ebb6a91bc33680e5ababe421f"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1c557ba1ba9e76bcf76b4aa15f5b7a09f53733997256ab7c94b14982fae9744"
    sha256 cellar: :any_skip_relocation, ventura:       "aaa2e4e99e253d094e78c59d3645852bbb6cc1f880561d64540e37e2828fe4d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c162a30b847e57f66c0084017610d670cc22e81d134bab2d07c8b66c61e8ebf"
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
