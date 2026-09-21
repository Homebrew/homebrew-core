class CyclonedxNpm < Formula
  desc "Creates CycloneDX Software Bill of Materials (SBOM) from npm projects"
  homepage "https://github.com/CycloneDX/cyclonedx-node-npm"
  url "https://registry.npmjs.org/@cyclonedx/cyclonedx-npm/-/cyclonedx-npm-6.0.1.tgz"
  sha256 "569c41869fbd969d6bd435fec2a0e035c7e442d4a8dad323e32b9baa80e1d9e7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "85639e6aab1a8a541a58b9bfdd9c9ef97e885e6e218e2f16a80f42971d43441d"
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
