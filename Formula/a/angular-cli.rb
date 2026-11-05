class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-22.2.6.tgz"
  sha256 "88b8cca8df15caa5dd1aab7334d9234fe29cb2b77666499101e90cee486c5fd1"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "36c748cd21831235f7aa85d6dc7ef2a2565fd8e0764ea223d08f7249407e6667"
    sha256 cellar: :any,                 arm64_tahoe:       "601c0717cfc5ad28e789d165ccb3a8d2e0793870284e5da2c6769b2d6ab553f7"
    sha256 cellar: :any,                 arm64_sequoia:     "59fc7b8b779c18996bde639026c88c993f88298616462d3aa071fa2e2b90f724"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bbf177c728c71f0da8d8b8cf3469d0562d8c27a1a81cb0314b39a123bc54b917"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ae198cf277df75a59ec061c39a43074dc726184934dfb71c31eb4f453b2cf3e6"
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
