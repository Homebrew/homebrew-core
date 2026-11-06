class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-22.2.6.tgz"
  sha256 "88b8cca8df15caa5dd1aab7334d9234fe29cb2b77666499101e90cee486c5fd1"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "8216c85c23d5250f33bb581bce470ebdfd87e54ad51745e834456855bb15fe76"
    sha256 cellar: :any,                 arm64_tahoe:       "7b373135dadc836a1ec94b60ee8325572700e3e0d0620f96d47f84cb9eb72b78"
    sha256 cellar: :any,                 arm64_sequoia:     "6fd9f46a037e87be0d612dff537be3feea5431eca3570e6a8d8b619e6b02639f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "19e52b8f84138fa6c931e4d8a95ebee2a82f1dfb877fd3d46752ef2772144a49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a96481b49c6018a4fe6464b04e416025f4293aef2681be5eb4d64ea81252822c"
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
