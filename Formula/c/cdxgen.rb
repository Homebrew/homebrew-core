class Cdxgen < Formula
  desc "Creates CycloneDX Software Bill-of-Materials (SBOM) for projects"
  homepage "https://github.com/CycloneDX/cdxgen"
  url "https://registry.npmjs.org/@cyclonedx/cdxgen/-/cdxgen-10.10.6.tgz"
  sha256 "10d36a1b4b6063d0dd7e03835d3c4f36edbe353501197a5d563cb350b0f7ce55"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20763427232d70d5a32ac720465cb0ac8a6e77908d8a2748049d56b3132465d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c5370fbf630725539c1ee79c15e3da2d90dd7329583898a19968ee404f65810"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "009e0c267fc2eb51743a4a52fd91e7f62f91405a840e2484222e134cacdf67f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "84967c741a9e6fe64fd0ce155a8b742de3afdfa2f37a01c3ca784b962f6e63f2"
    sha256 cellar: :any_skip_relocation, ventura:       "1a08953e30ae0f7d2d23cea341135cc67ffa75bf9f7d4c75bd4567082e856983"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c788daf4550fee567152c0a85b6cf547ea6eae7de13ad49766b94e34f8c4a474"
  end

  depends_on "node"

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
