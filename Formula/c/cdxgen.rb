require "language/node"

class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-10.4.1.tgz"
  sha256 "f884b4014e9460b630d36dbb33293797ec0ef94371ea6011bbfd8fbdc06c8853"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0d3540aa2dc963f81f5655bebce7c7409fb1ef6b4d5fc1daf755c123147ea9d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cad4be2e42438c5e8dc5b9b0b0214c1d9e30123db92c3dfc34078fa8e41451c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85bede4ca311850bb1e17b401018097df8a06122e059b32ded560679a6111939"
    sha256 cellar: :any_skip_relocation, sonoma:         "9ab5f790a3bca78874b185f06fdd4267ff9368e9a14971137af7c15f9bb6936c"
    sha256 cellar: :any_skip_relocation, ventura:        "dbb4dba35b74f4a9273718b445eb851d5baa242080d65eedc5562fd0e9b191cc"
    sha256 cellar: :any_skip_relocation, monterey:       "c6593bbed580e4ec7e95622e25a29905e33c3949fa5d25cac18d1454c35f5675"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "774fab24ff5e6d272340cac6c5684348c982b65272a223dd3ad4b1a2359132b8"
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
