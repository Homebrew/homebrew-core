class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-22.2.3.tgz"
  sha256 "a5097ef81e384d89f01ab68396ceaa5050e2cedbc60430b76d74820ef8d56117"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "2e17345fde34d58eab26300b8f7664d3ead127bed94746ba9a423c91929b2247"
    sha256 cellar: :any,                 arm64_tahoe:       "191f098a251a11e0c31b247bd107535c451807da81aa54cd8161eb66105c7933"
    sha256 cellar: :any,                 arm64_sequoia:     "3d9ac6b7840245337137bfdd281ce42f23986f3bf3fe82f0a5b7b8c9a34b52db"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7c3ea388ba3ef238acf74847f83b5859482ca3c6e444fda34717fd6d52c2cd2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "9e8e542c03cd63d1f6d8b7a8c5223aa93fa6e603139d4a9cb797df6bb5cddd28"
  end

  depends_on "node"

  on_macos do
    depends_on "rust" => :build

    # Rebuild the prebuilt `oxc-parser` binding as it lacks header space for relocation
    resource "oxc" do
      url "https://github.com/oxc-project/oxc/archive/refs/tags/crates_v0.150.0.tar.gz"
      sha256 "08a7d805dc76f773cc5aeafa4adebe276f841cc30671e19fa05f10258293e567"

      livecheck do
        url "https://registry.npmjs.org/@schematics/angular/latest"
        strategy :json do |json|
          json.dig("dependencies", "oxc-parser")
        end
      end
    end
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    return unless OS.mac?

    node_modules = libexec/"lib/node_modules/@angular/cli/node_modules"
    oxc_parser_version = JSON.parse((node_modules/"oxc-parser/package.json").read)["version"]
    odie "Update `oxc` resource to #{oxc_parser_version}!" if resource("oxc").version.to_s != oxc_parser_version

    resource("oxc").stage do
      system "cargo", "build", "--lib", "--locked", "--release", "--package", "oxc_parser_napi"
      arch = Hardware::CPU.arm? ? "arm64" : "x64"
      cp "target/release/liboxc_parser_napi.dylib",
         node_modules/"@oxc-parser/binding-darwin-#{arch}/parser.darwin-#{arch}.node"
    end
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_path_exists testpath/"angular-homebrew-test/package.json", "Project was not created"
  end
end
