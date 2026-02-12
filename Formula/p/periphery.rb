class Periphery < Formula
  desc "Identify unused code in Swift projects"
  homepage "https://github.com/peripheryapp/periphery"
  url "https://github.com/peripheryapp/periphery/archive/refs/tags/3.5.0.tar.gz"
  sha256 "8618d41870636b7231592d9bec06d346c68f3ab1f525fb0649411fe9feb9d390"
  license "MIT"
  head "https://github.com/peripheryapp/periphery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b3e6433d9a7878f053615c8fd5abed710f3300fdad96afc823cc88a115964c93"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e879fd7ef0b7542baf60435bd0178fd86b524d0ad536ce8d96662fd8b95620b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6eb39c56f0dbd8440a336c101d4e8353bd4207e08140c2a1557625abc69a7d68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf23dccbdd0680d6c04b73aade061b2beb864c25ce58b4f816204dc95ab21288"
  end

  uses_from_macos "swift" => [:build, :test]
  uses_from_macos "curl"
  uses_from_macos "libxml2"

  on_sequoia :or_newer do
    depends_on xcode: ["16.4", :build]
  end

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
