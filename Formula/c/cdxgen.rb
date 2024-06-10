require "language/node"

class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-10.6.1.tgz"
  sha256 "e9a061517b82024fa52f17afe90cb0488907de01c0a7f26d5216648dea2b4515"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "702a44c8e0e23ccb1fc9f63237e14420cd902d91008dad825ee6d317944056f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a11da77ea031d73cd7f0463ba76e08377e9daac56047d8d32470f3a06ef0013a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5275e92a02e2e19ca0eca94fff07314d0bffbc02de0a1c75c050698b34385abe"
    sha256 cellar: :any_skip_relocation, sonoma:         "eacab59efaccea92868df1bc003f6bfd2642c0e9bca6077762d15cc8eec18fb6"
    sha256 cellar: :any_skip_relocation, ventura:        "771e1b397b110c2f851d71892fc8ab4607fa9d253128b2a2b0dcb4b59f416fcc"
    sha256 cellar: :any_skip_relocation, monterey:       "e005b8564575f363b1b939700c980e84d91f25b65561232fe6b0922e469e8f08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b1cf1d68b6cfec270a0059b187bab4962e544fd1edc8e02757cdfb9e20e2007"
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
