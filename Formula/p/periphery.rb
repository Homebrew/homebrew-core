class Periphery < Formula
  desc "Identify unused code in Swift projects"
  homepage "https://github.com/peripheryapp/periphery"
  url "https://github.com/peripheryapp/periphery/archive/refs/tags/3.8.0.tar.gz"
  sha256 "0732e25b366ef019897b1fd9577579f6a472671701d08b0b83ad9413bc859004"
  license "MIT"
  head "https://github.com/peripheryapp/periphery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f15a284eb5136ad3f57886f3c58a175ee177eae01b0e4574e6c1d4ec9b8acf19"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af70d2f0d974fd39d099b14382ccffcbe1742bd0a818888a4050a8c8655f8a49"
    sha256                               arm64_linux:   "a8737879d7f4647e4f0e3de71f8552dbba0cfe7e55e357b9ff90f5d309a27a23"
    sha256                               x86_64_linux:  "523743acbbe6a4b623831033f479acb3abd04050b3fd742d3bea3cc1abedbeda"
  end

  # We need the CLT installed for libIndexStore.dylib.
  pour_bottle? only_if: :clt_installed

  # https://github.com/peripheryapp/periphery/commit/56a0eb6fb97b785c8fbc1044ccbc7b5d9f06ebec
  deprecate! date: "2026-08-12", because: :repo_archived
  disable! date: "2027-08-12", because: :repo_archived

  uses_from_macos "curl"
  uses_from_macos "libxml2"
  uses_from_macos "swift"

  on_macos do
    depends_on xcode: ["16.4", :build]
  end

  def clt_lib_directory
    on_macos do
      "#{MacOS::CLT::PKG_PATH}/usr/lib"
    end
  end

  def install
    libindexstore_dir = OS.mac? ? clt_lib_directory : "#{formula_opt_libexec("swift")}/lib"
    args = ["-Xlinker", "-rpath", "-Xlinker", libindexstore_dir]

    system "swift", "build", "--product", "periphery", *args, *std_swift_args
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
