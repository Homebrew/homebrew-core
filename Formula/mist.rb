class Mist < Formula
  desc "Mac command-line tool that automatically downloads macOS Firmwares / Installers"
  homepage "https://github.com/ninxsoft/mist-cli"
  url "https://github.com/ninxsoft/mist-cli/archive/refs/tags/v1.9.tar.gz"
  sha256 "79f259ff10a56f7d01a43fcd9525680f237a0955631cae54dbb33c924f0ddc54"
  license "MIT"
  head "https://github.com/ninxsoft/mist-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8214125ac548a63db1c1ea0b59c0b315b15ca8497809d6e1d5587d3c18ac3919"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2de8592da1c11ff5d2dd5a6b9c78caca53641d481f4ee642aa11277be3d2d519"
    sha256 cellar: :any_skip_relocation, monterey:       "359271650bdc927599b8a19a78b97392cd352e8c415defd4eec4f0de0a0ad5a4"
    sha256 cellar: :any_skip_relocation, big_sur:        "117db2644b9547c56bd56adfde3d8285ee7c3fa8391dcd3d5b493574d3c29c16"
  end

  # Mist requires Swift 5.5
  depends_on xcode: ["13.1", :build]
  depends_on :macos
  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/mist"
  end

  test do
    # basic usage output
    assert_match "-h, --help", shell_output("#{bin}/mist").strip

    # check we can export the output list
    out = testpath/"out.json"
    system bin/"mist", "list", "firmware", "--quiet", "--export=#{out}", "--output-type=json"
    assert_predicate out, :exist?

    # check that it's parseable JSON in the format we expect
    parsed = JSON.parse(File.read(out))
    assert_kind_of Array, parsed
  end
end
