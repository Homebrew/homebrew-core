class Periphery < Formula
  desc "Identify unused code in Swift projects"
  homepage "https://github.com/peripheryapp/periphery"
  url "https://github.com/peripheryapp/periphery/archive/refs/tags/3.1.0.tar.gz"
  sha256 "14ff391e6438301e0640da82160dd55da981b773967ce3930a2366a301142fd1"
  license "MIT"
  head "https://github.com/peripheryapp/periphery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90ad3d39f0c214a787731e6efde1dc501ae5afe9fc552495261b02e93fe0ff1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e41cb8cb73325e37d7db58465aa8a55f243766037b520ffdb7cec208a48a101"
    sha256 cellar: :any_skip_relocation, sonoma:        "c03608455e65262df0c604ddd83cdc93524df9a4005fe6eb0c80172685e1367a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed618fe7a6c9d2fe5ecd0d9916d93c11da6fad57382b9207a3c298442d333db2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c976edd4df2f4218896580dc677e3547f1bad2b12e992e42af3297a23960b0ec"
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
