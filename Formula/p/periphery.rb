class Periphery < Formula
  desc "Identify unused code in Swift projects"
  homepage "https://github.com/peripheryapp/periphery"
  url "https://github.com/peripheryapp/periphery/archive/refs/tags/2.21.2.tar.gz"
  sha256 "97e399df17d1e681703c5c8852e50b40c056a98b41dc4c615011c048b8348dbb"
  license "MIT"
  head "https://github.com/peripheryapp/periphery.git", branch: "master"

  depends_on xcode: ["15.4", :build]
  depends_on macos: :sonoma

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
    system "swift", "package", "init", "--name", "test", "--disable-xctest", "--disable-swift-testing"
    system "swift", "build", "--disable-sandbox"
    manifest = shell_output "swift package --disable-sandbox describe --type json"
    File.write "manifest.json", manifest
    system bin/"periphery", "scan", "--strict", "--skip-build", "--json-package-manifest-path", "manifest.json", \
      "--verbose"
  end
end
