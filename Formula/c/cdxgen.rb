class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-10.10.0.tgz"
  sha256 "c0ddc1c737309b8201dda9843d74949fbda4f57ce847989a58d57112a273e12b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53b7d01a3f01faaafb578895f5fa48658639bb8f12d05e1f2d982950349df0e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aec86c41f4448e90af5a870af554deacbd503702af971b6faecf39e5a005b5d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e28848ef5ae0bc580df20f5ca7fa5d96cb7a1c956ff76ec7291e272f5edcd8e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "7bd81fc20d3df5c63d9a71165a03998088f714779e4507ae59ff382867c394d2"
    sha256 cellar: :any_skip_relocation, ventura:       "23b00f7b78395ce1fb01bff01ccaab62394cd66ff5be3be21e8223f7a06185ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef757815d4e5f4bd41c35bee33d496b3ee2818dcbbcd1a40134ea6490c37acad"
  end

  depends_on "node"

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
