class Periphery < Formula
  desc "Identify unused code in Swift projects"
  homepage "https://github.com/peripheryapp/periphery"
  url "https://github.com/peripheryapp/periphery/archive/refs/tags/3.2.0.tar.gz"
  sha256 "84041cf27e1f7b1f9981651f0d7c78b317388040f1f31cf131dabb744a5f922c"
  license "MIT"
  head "https://github.com/peripheryapp/periphery.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "499b5f157fb2ecfdc66cc3dcb58b185f6b16b1827dd8c1091864dacc00c5fe92"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2b0dea494e8bd21ff932fa10fac318cf2ee06c758e6797ecb23f99a6f8d2460"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "400cd8658c47b54ab5060f11df16ee035d1673aa3abd2c0244669121c744d570"
    sha256 cellar: :any_skip_relocation, sonoma:        "df2656985ae7b056868b3f3acf2de20abd266cbd52d9d5ae31eaae77ea447ea5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb205dd64182f1a1b904bd0187ecb81156bdeb1a38d74476afc9a1bae87654b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4c6039249d029db5538c4d1f96014905f6d01914ecae26a8d0a76af0009fe77"
  end

  depends_on xcode: ["16.0", :build]

  uses_from_macos "swift" => [:build, :test]
  uses_from_macos "curl"
  uses_from_macos "libxml2"

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end
    system "swift", "build", *args, "--configuration", "release", "--product", "periphery"
    bin.install ".build/release/periphery"
    generate_completions_from_executable(bin/"periphery", "--generate-completion-script")
  end

  test do
    # Periphery dynamically loads 'libIndexStore' at runtime and must find its location depending on the host OS.
    # On macOS, the library is bundled within Xcode at a consistent location. On Linux, the library path is assumed
    # to be at 'lib/libIndexStore.so' relative to the path of the 'swift' binary, which is a reasonable assumption for
    # most installations. However, this is not the case on the Homebrew Linux test container, and the shared libraries
    # do not appear to be present.
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "swift", "package", "init", "--name", "test", "--type", "executable"
    system "swift", "build", "--disable-sandbox"
    manifest = shell_output "swift package --disable-sandbox describe --type json"
    File.write "manifest.json", manifest
    system bin/"periphery", "scan", "--strict", "--skip-build", "--json-package-manifest-path", "manifest.json"
  end
end
