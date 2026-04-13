class Periphery < Formula
  desc "Identify unused code in Swift projects"
  homepage "https://github.com/peripheryapp/periphery"
  url "https://github.com/peripheryapp/periphery/archive/refs/tags/3.6.0.tar.gz"
  sha256 "c922f700df77a199fabe3f671b424c5f0177c8760cf778e45061e9ac18a4ba48"
  license "MIT"
  head "https://github.com/peripheryapp/periphery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7206b948c99b5de7d582085a2b6b4033e66f0ce788e1a13dcaf2900415aa75a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01ccc914b3a5bf43320833fcfee697a64d4f8fc211d4426c34db7bdabf34ec25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9f0dac9c9b5a2bc8eababa69481bc41b2df5459595f48c7984ef37a04a3978a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e009dab6e5079c82adb0cf6c2818b7a76dec6dc23b7c6331cfb70c65d4e42ef9"
  end

  depends_on xcode: ["16.4", :build]

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
    ENV.prepend_path "PATH", Formula["swift"].opt_libexec/"bin" if OS.linux?

    system "swift", "package", "init", "--name", "test", "--type", "executable"
    system "swift", "build", "--disable-sandbox"
    manifest = shell_output "swift package --disable-sandbox describe --type json"
    File.write "manifest.json", manifest
    system bin/"periphery", "scan", "--strict", "--skip-build", "--json-package-manifest-path", "manifest.json"
  end
end
