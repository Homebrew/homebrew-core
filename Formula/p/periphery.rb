class Periphery < Formula
  desc "Identify unused code in Swift projects"
  homepage "https://github.com/peripheryapp/periphery"
  url "https://github.com/peripheryapp/periphery/archive/refs/tags/3.0.1.tar.gz"
  sha256 "6498ba5bf27b5e0ea76e254538f1c5f9a38b828b26edb9d2e6b46db6c05f91c2"
  license "MIT"
  head "https://github.com/peripheryapp/periphery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96c2f0238151f5188a49ece048a9785e9f24b666b8bc0bb9e2d2327cb054e12e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87fbc7c79dab6923f84c1e272c5aacab2ef2d8b5c7e2ecf28d2bab1053f8fc96"
    sha256 cellar: :any_skip_relocation, sonoma:        "c14f209082f30711ddbb243ff87b462d53519e01b562bb832a3c6c03340ea4f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01fcf34cc76e455ea3f5f134260d20c84c6fe8091ae266e1723cec4d7d5d2ad8"
  end

  depends_on xcode: ["15.4", :build]

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
