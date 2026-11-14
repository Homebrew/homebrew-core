class CyclonedxNpm < Formula
  desc "Creates CycloneDX Software Bill of Materials (SBOM) from npm projects"
  homepage "https://github.com/CycloneDX/cyclonedx-node-npm"
  url "https://registry.npmjs.org/@cyclonedx/cyclonedx-npm/-/cyclonedx-npm-7.0.1.tgz"
  sha256 "a2c52873f41c5edf1372db994d66de5641674156a0ad4c16e095641c408f6310"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d5377c6571ed4e5a7f278eb2b9cdf944c300ca0aa525bf0695fe9e41aea2429b"
  end

  depends_on "node"

  resource "homebrew-package.json", :test do
    url "https://raw.githubusercontent.com/CycloneDX/cyclonedx-node-npm/43bf9e7e176c4eb3c2d648a5c462f0bf7f401c89/demo/package-integrity/project/package.json"
    sha256 "2de23dea5663204981638ff9eb4815092fbc34ba93397469be957a306ce6fb24"
  end

  resource "homebrew-package-lock.json", :test do
    url "https://raw.githubusercontent.com/CycloneDX/cyclonedx-node-npm/43bf9e7e176c4eb3c2d648a5c462f0bf7f401c89/demo/package-integrity/project/package-lock.json"
    sha256 "f7570777484bc3f03041264dbe6e9c8ca46b02a55187cda849f3e338aa627d4a"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cyclonedx-npm --version")

    testpath.install resource("homebrew-package.json"), resource("homebrew-package-lock.json")

    system bin/"cyclonedx-npm", "--package-lock-only", "-o", "sbom.json"
    assert_match "pkg:npm/base64-js@1.3.1", (testpath/"sbom.json").read
  end
end
