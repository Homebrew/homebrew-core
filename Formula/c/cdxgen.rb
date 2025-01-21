class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-11.1.0.tgz"
  sha256 "9e3cb280a15128c3e80972e6b71211ae11314e9105f05a12f15ec65ff4f23116"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "985a2045b57856fdf91801fadc51f05edbfe89d24f0daf0637aa7c44edf11812"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26844ef60d856146a78b8b1a8d43b8691d235fa0469cb539befa6c936b09cc1f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "61cf704b05482287f9e3fc113d10787f615791e3ece92b703e718195f227e364"
    sha256 cellar: :any_skip_relocation, sonoma:        "4812036d19d05472dd34b31b46a8f170e6673aeddbbda93555d0ddf981b544cb"
    sha256 cellar: :any_skip_relocation, ventura:       "294a8944ed37885af5363ce24de40cfbdc1c1f9dc546a67c1e6637fdb6fced24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a131e06b17ca3cdaf7a71ed56568f3c13682e95de0f7cc268a69aefadcd1d9ea"
  end

  depends_on "node"

  uses_from_macos "ruby"

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

    # Remove pre-built osquery plugins for macOS arm builds
    osquery_plugins = node_modules/"@cyclonedx/cdxgen-plugins-bin-darwin-arm64/plugins/osquery"
    rm_r(osquery_plugins) if OS.mac? && Hardware::CPU.arm?
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
