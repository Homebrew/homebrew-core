require "language/node"

class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-10.1.3.tgz"
  sha256 "6004776f9abf196f9500d80700fc23f151488bbf731b492aedb97caccd0cda58"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0f63e8b37ca4cc5f552c6ebfc69df6ccedd8dc1405f020e7724f139cb1e085f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b546e71610fcd2faf08b774c8ff8b9c4bc6f1e3ca7c84a18fce3aa55b9067786"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05e502b1f9c65eef6ce4dcad45cc5d37ad7b297d52a9f428ef7feaa3b7a59858"
    sha256 cellar: :any_skip_relocation, sonoma:         "e882b21a697b6ed078c964687b782dbce67fa74342260c74182a31ece37aacda"
    sha256 cellar: :any_skip_relocation, ventura:        "d1678a1978ccf0a6b8660d30027601b22f388075e7272a8b8d56896951b776b3"
    sha256 cellar: :any_skip_relocation, monterey:       "1188a212b4d64f4ef502087cd6dcc785af199513cb2b879854528b4d82686667"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25d655f6b3bbae2dca226083d1803de75e716f6f3be961d3f6efcb12b9b36c56"
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
