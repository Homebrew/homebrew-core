class Periphery < Formula
  desc "Identify unused code in Swift projects"
  homepage "https://github.com/peripheryapp/periphery"
  url "https://github.com/peripheryapp/periphery/archive/refs/tags/3.7.3.tar.gz"
  sha256 "481dbd108f1222ac7afe6b67cea729132466613bada02314c4ddb4d5d338498d"
  license "MIT"
  head "https://github.com/peripheryapp/periphery.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "25a1cdb3b1adcaf3a5c6ede8e55f44ad379acabaacf44f3a7b11066f521e4fa7"
    sha256 cellar: :any,                 arm64_sequoia: "9ce7f186010d9e3f768acb1c2588fe1c07af759bc498724c20807c788d2786c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4841673495dcb3f05ef66981dd4c23fa334b3fec895dc7bde8fa0104984d5132"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27162bc80b8728c8c8be65b8925b489a0e68dd9b4228b0371e3b2e843bd649fc"
  end

  depends_on xcode: ["16.4", :build]

  uses_from_macos "curl"
  uses_from_macos "libxml2"
  uses_from_macos "swift"

  # Update to commit referenced in https://github.com/peripheryapp/periphery/blob/<version>/Package.swift
  resource "swift-index-store" do
    on_linux do
      url "https://github.com/MobileNativeFoundation/swift-index-store/archive/7edb9a64e084ed64f83b84fb9269d3d1a20c0687.tar.gz"
      sha256 "caa6aaf989d7a886bf3a7d8c72128d83a1cab5bf15480eec347dda5a87d2216b"
    end
  end

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      swift_lib = Formula["swift"].opt_libexec/"lib"

      resource("swift-index-store").stage buildpath/"swift-index-store"

      inreplace buildpath/"swift-index-store/Package.swift" do |s|
        # The `swift-index-store` package adds an rpath to the location of `swiftc` plus /lib.
        # This approach can lead to issues in Homebrew build, as the location is a supershim,
        # resulting in supershim path beeing an rpath inside the binary
        s.gsub!(
          /let\s+toolchainLibDir\s*=\s*URL\(fileURLWithPath:\s*swiftcBin\)\.resolvingSymlinksInPath\(\)\s*
            \.deletingLastPathComponent\(\)\.deletingLastPathComponent\(\)\.appendingPathComponent\("lib"\)\.path/mx,
           "let toolchainLibDir = \"#{swift_lib}\"",
        )
      end

      # Use the patched `swift-index-store` package
      system "swift", "package", "edit", "swift-index-store", "--path", buildpath/"swift-index-store"

      ["--static-swift-stdlib", "-Xswiftc", "-use-ld=ld"]
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
