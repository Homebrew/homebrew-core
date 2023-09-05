require "language/node"

class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-9.7.1.tgz"
  sha256 "8889415f0d87b579ad56bd215301cff5019e6cc9c2565a02d9fccc0957b94f03"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "288c9148327d918b30bce6242e8eb2e098d30c5a70793d3b7bbbd95c17154e8d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e67cb77a6f8ce95454210548176e074d6ec75dbc207cd26bce9b9b22b77c59de"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d602e8d24898865e2d5964bd4e9e6f8b165199bbba91a819eb7f106d074fe67b"
    sha256 cellar: :any_skip_relocation, ventura:        "256b230ed22605b64b96ff60e436688ec667ffe9a46f85938bc2e1b66ee1f2c0"
    sha256 cellar: :any_skip_relocation, monterey:       "70df1b65f5e62887d6569488322a139ee89d47d9ed07a4b661c89aacdf4d863b"
    sha256 cellar: :any_skip_relocation, big_sur:        "f0552b2c14c69017fba1f790c45f1183f00c16dc101bbdc9e06676898515bca9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "faa1fbbb7feca4119bf8f9ef18d3ed141f2e70d44ede93d7b7c9c5ff05a2b869"
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

    assert_match "BOM includes 1 components and 0 dependencies", shell_output("#{bin}/cdxgen -p")

    assert_match version.to_s, shell_output("#{bin}/cdxgen --version")
  end
end
