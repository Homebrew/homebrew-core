require "language/node"

class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-9.8.9.tgz"
  sha256 "64b220a26a377973b30142e840994462c90057d4cef7ccde2a3404f3ec1cd40a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "71de39e3adff5a36320fc4dbfd9ae10df502e943a5e0972713249e733fc76be9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af1e839fa2106d95b8aff7167428b7b41486123482b21389b3ab523f0b7d20b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4561ff8ef7df9fe6bedcec6d510058afb0da8e24bb8c36c14161f2a97581ca21"
    sha256 cellar: :any_skip_relocation, sonoma:         "57623d893ea6400c564643c4e33df3afde1734f981ee970be4b46a0627e6a83b"
    sha256 cellar: :any_skip_relocation, ventura:        "87b5f797e4382739ecc110fe10c2a72c838e5528b24b914f46e55fd52bde23de"
    sha256 cellar: :any_skip_relocation, monterey:       "618eaba0c2173f891df503f03ef3a26050ac427b213abe07488f1b8dc5a1bafb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57a9b292d83565080cd514d67fb1e56286ab659ddbc927e4c7d23cf9c7a19194"
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
