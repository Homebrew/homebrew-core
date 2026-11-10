class CyclonedxNpm < Formula
  desc "Creates CycloneDX Software Bill of Materials (SBOM) from npm projects"
  homepage "https://github.com/CycloneDX/cyclonedx-node-npm"
  url "https://registry.npmjs.org/@cyclonedx/cyclonedx-npm/-/cyclonedx-npm-7.0.0.tgz"
  sha256 "61f7d4df91d0c9d9f4ecf97de78fa666c31f10a364cbe0b70272a234117b0eed"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ec05539fcdaea18a0d69ff99b9d1d74aed54992c1c7753f123c3fc0cabf5db07"
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
