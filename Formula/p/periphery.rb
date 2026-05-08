class Periphery < Formula
  desc "Identify unused code in Swift projects"
  homepage "https://github.com/peripheryapp/periphery"
  url "https://github.com/peripheryapp/periphery/archive/refs/tags/3.7.4.tar.gz"
  sha256 "6e3eb93904d4ea3ba346526b3e7dd90d0d258d4eff91977b859b91115f028711"
  license "MIT"
  revision 1
  head "https://github.com/peripheryapp/periphery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b8a3b74aa0c3f8c01aa5f9d479391017072d01f019c336d8e835b52dad47c68"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a1dc3ad761d6dd38204a9ca8cd513fd77f580dd47150c159691fbf842b71a97"
    sha256                               arm64_linux:   "092a72a761a35ab7d3c14b7a08f673579695ef6c4e883b1c745dc4fe87e34919"
    sha256                               x86_64_linux:  "24907907f0325d589e4ce5963553fc243b59a551d350c0deb994e100f36d34b6"
  end

  # We need the CLT installed for libIndexStore.dylib.
  pour_bottle? only_if: :clt_installed

  depends_on xcode: ["16.4", :build]

  uses_from_macos "curl"
  uses_from_macos "libxml2"
  uses_from_macos "swift"

  def clt_lib_directory
    on_macos do
      "#{MacOS::CLT::PKG_PATH}/usr/lib"
    end
  end

  def install
    args = if OS.mac?
      ["--disable-sandbox", "-Xlinker", "-rpath", "-Xlinker", clt_lib_directory]
    else
      swift_cellar_libexec_lib = Formula["swift"].libexec/"lib"

      ["--static-swift-stdlib", "-Xswiftc", "-use-ld=ld", "-Xlinker", "-L#{swift_cellar_libexec_lib}", "-Xlinker",
       "-rpath", "-Xlinker", swift_cellar_libexec_lib.to_s]
    end
    system "swift", "build", *args, "--configuration", "release", "--product", "periphery"
    bin.install ".build/release/periphery"

    generate_completions_from_executable(bin/"periphery", "--generate-completion-script")
  end

  test do
    system "swift", "package", "init", "--name", "test", "--type", "executable"
    system "swift", "build", "--disable-sandbox"
    manifest = shell_output "swift package --disable-sandbox describe --type json"
    File.write "manifest.json", manifest
    system bin/"periphery", "scan", "--strict", "--skip-build", "--json-package-manifest-path", "manifest.json"

    return unless OS.mac?

    assert_includes (bin/"periphery").rpaths, clt_lib_directory
  end
end
