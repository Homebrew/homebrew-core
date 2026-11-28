class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-22.3.0.tgz"
  sha256 "cb7eb35f2aa5242e5e161c5a906eaf2f72dd78423d3dcff1b564ef8a23646336"
  license "MIT"

  bottle do
    manifest_sha256 "c6e0f4abaf0c2fb1925a102479943c94e086a355c8e0d33ba0f1acfe42521c51"
    sha256 cellar: :any,                 arm64_golden_gate: "0d570cccad2b6113affa89b9a5acdd9b29badf457117e4143a6401f57112e7c7"
    sha256 cellar: :any,                 arm64_tahoe:       "d42f7af670da8c9cbbbb0d8599354611caf701fe565e52e839805848a821a898"
    sha256 cellar: :any,                 arm64_sequoia:     "0aab1e9039d340eb6724a6288cc6e77e2a14bd5c80d59b4e6e15f6a519a7cc1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "556d1216c9aff4ae2554ecf7dd5c5f3d3d1acc4cbd33e07ac7fa6934e22cb0d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "b9c5bf939b37630ed859e7d564f59cdd544c2ba5ec18d65cc2023eb815ffe377"
  end

  depends_on "node"

  on_macos do
    depends_on "rust" => :build

    # Rebuild the prebuilt `oxc-parser` binding as it lacks header space for relocation
    resource "oxc" do
      url "https://github.com/oxc-project/oxc/archive/refs/tags/crates_v0.158.0.tar.gz"
      sha256 "c26aeb000af3ab57bd65b237a857444f4b0d955a5df7bd06a3356e4f62e51e66"

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
