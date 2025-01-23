class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-11.1.2.tgz"
  sha256 "3971837f38572f36cab685abbf7f68c5699c4ffde0a239f6c878cb7d91d0e9ad"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50b8e8825b89561c3e3f487bbbe9310a20df6ed5b9c1dd571556bc87889b2433"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35f16e30263d49698477058ff360ce15890703213f25b6871990e45126650a27"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5725bc099278f7e969f4ab972973d8f94f406add29b00dbdaa59ac49ce1d3e21"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3de0f9756a93f94a89283aeb28fe3546cd7a25476a4445645c870e3e82c2395"
    sha256 cellar: :any_skip_relocation, ventura:       "823797ca525260a3663f02ef3e00f7182705afb5e7984895a85f92fd951e5b57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38a9484f27fae4f52debbba276e5aa56e2e58638384d5d92836d1cbe9a18030e"
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
