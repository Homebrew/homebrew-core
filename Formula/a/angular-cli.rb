class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-22.2.8.tgz"
  sha256 "be53b34de12a9e7ad6e995bfea7df484b446ca7cbd2c58a239bcdc02a88f928d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "91101af4147d2c19597714b6f6e04920f3c1960e76506f7b38fe5c65597606d5"
    sha256 cellar: :any,                 arm64_tahoe:       "799f9ff1b8e1e6b1532b358a3b0324f55a51fca068071083ea125f526556aaeb"
    sha256 cellar: :any,                 arm64_sequoia:     "d7a4b691e65a9eb900c6c1b6708fb4d93ff05fe9e72dac4776e2e8e4204fdde4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "50bb91b4d3eb6e4865e9f36436582f0078781f7190bfa4c4894dde08b95944a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "34ae5dd9ce72ac50e6ee3e24cbe82a2e70c08000ef7ccef8164dcf962040936a"
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
