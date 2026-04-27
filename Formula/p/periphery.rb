class Periphery < Formula
  desc "Identify unused code in Swift projects"
  homepage "https://github.com/peripheryapp/periphery"
  url "https://github.com/peripheryapp/periphery/archive/refs/tags/3.7.4.tar.gz"
  sha256 "6e3eb93904d4ea3ba346526b3e7dd90d0d258d4eff91977b859b91115f028711"
  license "MIT"
  head "https://github.com/peripheryapp/periphery.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e1c491a5c1dc82e247ca241433a5e06e9102d5b990dd990041bf6a8bb14e0ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a795a73bb0537e622e971e79eeeb1e15376961c726ef252a8a2315a51f697aad"
    sha256                               arm64_linux:   "b987c8031b3d4fdb652cd846eff55a3c4414995b64f4a87afc9651ea44fc9f21"
    sha256                               x86_64_linux:  "703779b1a182165b076a38704fc21045826d6f091f703c9681c9229275b33e35"
  end

  depends_on xcode: ["16.4", :build]

  uses_from_macos "curl"
  uses_from_macos "libxml2"
  uses_from_macos "swift"

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
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
  end
end
