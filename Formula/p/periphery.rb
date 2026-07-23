class Periphery < Formula
  desc "Identify unused code in Swift projects"
  homepage "https://github.com/peripheryapp/periphery"
  url "https://github.com/peripheryapp/periphery/archive/refs/tags/3.7.4.tar.gz"
  sha256 "6e3eb93904d4ea3ba346526b3e7dd90d0d258d4eff91977b859b91115f028711"
  license "MIT"
  revision 2
  head "https://github.com/peripheryapp/periphery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "987dee5c4d72d83900414d8dea4c24474199babb6caca71715d079d763503663"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fa3b76c9726403809452f07bd93664e012ce72cd703fbe4d0d53871e529b0a4"
    sha256                               arm64_linux:   "28aa02d6bf2541e2825b3ec0a2145c3668705a92a41e893d1e3efd2c42ea1dde"
    sha256                               x86_64_linux:  "f0e6dcc81835afb7a346c45a39efbe697424ea24847a839da7adff179d96502c"
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
