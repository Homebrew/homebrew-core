class Periphery < Formula
  desc "Identify unused code in Swift projects"
  homepage "https://github.com/peripheryapp/periphery"
  url "https://github.com/peripheryapp/periphery/archive/refs/tags/3.2.0.tar.gz"
  sha256 "84041cf27e1f7b1f9981651f0d7c78b317388040f1f31cf131dabb744a5f922c"
  license "MIT"
  head "https://github.com/peripheryapp/periphery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c314b1a1ce15e2ff50ddab92984142cc48128665bf1fda0f2da5077b7c450ce8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1051052582167b3489ae50add5646f8356e991963ab5c133d1b65d900b87ad4c"
    sha256 cellar: :any_skip_relocation, sonoma:        "85963a0568c0c3b78b5d9dda3a53ff82186a03049b49d977fc57a000d246b8d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3865a7e57f405764e5e4a2fdca11a472e44d3eb6e0606acf4cdfcdde2cbd4871"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7f6e1fddcebfec563dda91aeefae9a256e42fe5c1065a7e8826fc45b5b9d02e"
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
