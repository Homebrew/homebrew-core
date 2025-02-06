class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-11.1.7.tgz"
  sha256 "97ea40b33a21b45a21c50f3600512f7e02c39018e8dea74d3f9966080284b44c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d60847ed7a369f06afac966bde19048f93874ed94fad04359d88875e26470a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf1acc111b7815e8a1a741f5cd7f6428b1d491e4209b73123162b0fc7bb99da2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "da67fb72f4bb00103ee57a6f0b806541051cf1807f606679089c1bc553125cfc"
    sha256 cellar: :any_skip_relocation, sonoma:        "41a34e95819bc06984c015f09fa63bffc26217b511506f5e26185fd142029f4d"
    sha256 cellar: :any_skip_relocation, ventura:       "74f4ea35d3e2e2291db80795198d9a343fccb21cd5020306625674e3141f7850"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e0c9a8f6f2d1576154bd25b1b60040d0186136ba94e4ebc3ab84ba2849a23b9"
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
