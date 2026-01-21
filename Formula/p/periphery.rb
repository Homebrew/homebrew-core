class Periphery < Formula
  desc "Identify unused code in Swift projects"
  homepage "https://github.com/peripheryapp/periphery"
  url "https://github.com/peripheryapp/periphery/archive/refs/tags/3.4.0.tar.gz"
  sha256 "6b053a1c36503d7fbb9f812940ae2300cca0a499a5131c8a5e550dc760881370"
  license "MIT"
  head "https://github.com/peripheryapp/periphery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47b0a82b8ea7145e58bf6777ae5fd0669ce3c1aa07a9575e269f79a6619dc6bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc1de77ee5f933e45565a7fd091e0ff6e80f00765c2d2aaa0f6f67e768719ec2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ba5f8e1a305e25cc29a1b71db4bf3d7a041e1e20ba6c34c4013bbe21f7d3248"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ed6185164fba6094ba666edb7ae10311013ca03ddc6c53bd066e61eea381e0a"
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
