require "language/node"

class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-10.2.2.tgz"
  sha256 "d6423b6c296ad933067b867f6fa8ad8b158c1cf29db9971a1edfe88aec5f479f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "067c6b440a301404e3bba043384b647fc2cedb5f956ae170dcff0bd6f85fc3a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "889736a0a58b4a3afd68e81eedf78ed56c66b623bfc3bf2e4d49998306f5bab7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "facc66abd2cfe4a2ff8e60a2a0266bed0545e066ce6df85216b45527b6ae3c6e"
    sha256 cellar: :any_skip_relocation, sonoma:         "0db12340502d5ed4d95f699e239edd288d0244b3424738fdbe0e6853d848d0fa"
    sha256 cellar: :any_skip_relocation, ventura:        "716bcc0730406f1c6d723b563f4a2849d0494d58441cd380621e70dc7e62cd0e"
    sha256 cellar: :any_skip_relocation, monterey:       "60e428ffcc44a050e81de4f49db38ef7c9eaedce93ecc5b34952110e88713d7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74fcc6aeca9e98b487b8ec0ec138bf556d80fb61a7d54fa1bfdf8b61e20c6181"
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
