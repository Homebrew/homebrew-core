class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-22.2.7.tgz"
  sha256 "f77fef613d5afac2d68b5a0f80153655b58b07d6cc8c4f21f2682e5f57b9950b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "5c4fd2510031645562cc41de59299b0db09d72fae71708f226569c656927e6cd"
    sha256 cellar: :any,                 arm64_tahoe:       "4c57d6fe437fe256dfa7b2d8231c6c635090358f43843524192a868b417a47f9"
    sha256 cellar: :any,                 arm64_sequoia:     "4053d18b622fff6a838f45766d0afde1228d83887c9852e926ea3921d2bf26eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "282f71761f5a05618f271411f5e917d6b253f269ba44b42fc20f6e21470dda74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "6c4d25117f40e6692b3a1f0b3f3461595e25fdb2aa814892c4232aa4c23bfe2d"
  end

  depends_on "node"

  on_macos do
    depends_on "rust" => :build

    # Rebuild the prebuilt `oxc-parser` binding as it lacks header space for relocation
    resource "oxc" do
      url "https://github.com/oxc-project/oxc/archive/refs/tags/crates_v0.156.0.tar.gz"
      sha256 "6d27e3c3458bffbd466091dbfd9edda06021e77aa680f508dfaafe8406669c6d"

      livecheck do
        url "https://registry.npmjs.org/@schematics/angular/latest"
        strategy :json do |json|
          json.dig("dependencies", "oxc-parser")
        end
      end
    end
  end

  allow_network_access! :build

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
