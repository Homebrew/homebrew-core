class CyclonedxNpm < Formula
  desc "Creates CycloneDX Software Bill of Materials (SBOM) from npm projects"
  homepage "https://github.com/CycloneDX/cyclonedx-node-npm"
  url "https://registry.npmjs.org/@cyclonedx/cyclonedx-npm/-/cyclonedx-npm-6.0.0.tgz"
  sha256 "ef9a69a08252641166e8f4b5a0d743b337fe519350c18d2907da76e63c1da2fd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "640f9ee7f16ec724a87965672d76cf8897a13775db405d382f1a101f8931a87c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cyclonedx-npm --version")

    resource "homebrew-package.json" do
      url "https://raw.githubusercontent.com/CycloneDX/cyclonedx-node-npm/43bf9e7e176c4eb3c2d648a5c462f0bf7f401c89/demo/package-integrity/project/package.json"
      sha256 "2de23dea5663204981638ff9eb4815092fbc34ba93397469be957a306ce6fb24"
    end
    resource "homebrew-package-lock.json" do
      url "https://raw.githubusercontent.com/CycloneDX/cyclonedx-node-npm/43bf9e7e176c4eb3c2d648a5c462f0bf7f401c89/demo/package-integrity/project/package-lock.json"
      sha256 "f7570777484bc3f03041264dbe6e9c8ca46b02a55187cda849f3e338aa627d4a"
    end
    testpath.install resource("homebrew-package.json"), resource("homebrew-package-lock.json")

    system bin/"cyclonedx-npm", "--package-lock-only", "-o", "sbom.json"
    assert_match "pkg:npm/base64-js@1.3.1", (testpath/"sbom.json").read
  end
end
