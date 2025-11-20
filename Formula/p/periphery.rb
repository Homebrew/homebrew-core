class Periphery < Formula
  desc "Identify unused code in Swift projects"
  homepage "https://github.com/peripheryapp/periphery"
  url "https://github.com/peripheryapp/periphery/archive/refs/tags/3.2.0.tar.gz"
  sha256 "84041cf27e1f7b1f9981651f0d7c78b317388040f1f31cf131dabb744a5f922c"
  license "MIT"
  revision 1
  head "https://github.com/peripheryapp/periphery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aaef4e2bf75a0d13e848bc4ba24715201ee84ef9011e9336babfdf15469d93b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24bef6d4f8a9d60c9869b28a4591dfb0934de4b7a9242976a03162612867d0af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b378ac137b7b38794fc86f3ecb774251fc75912c3a3c77b5da2d58eb3e85a818"
    sha256 cellar: :any_skip_relocation, sonoma:        "276521211fb06f701b5f75892af380a558abc2448f319fc1ddacba8f7b117b55"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7555deab2f6238fd87867b28c8b823031c74eda9c1376c805aeee2c0c3c6928b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f158a2c187e10d04a853be4ad50c6ca0db0e89249d1b7b2fc6b9aa6855c1405"
  end

  depends_on xcode: ["16.0", :build]

  uses_from_macos "swift" => [:build, :test]
  uses_from_macos "curl"
  uses_from_macos "libxml2"

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib", "-Xswiftc", "-use-ld=ld"]
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
