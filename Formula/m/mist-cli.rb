class MistCli < Formula
  desc "Mac command-line tool that automatically downloads macOS Firmwares / Installers"
  homepage "https://github.com/ninxsoft/mist-cli"
  url "https://github.com/ninxsoft/mist-cli/archive/refs/tags/v2.1.tar.gz"
  sha256 "ed2d07cf4e7f23aecb17ccdff8bdffdcf0d8ab20bbc799c78fed4a354a85de11"
  license "MIT"
  head "https://github.com/ninxsoft/mist-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "09e14b6d895615e07e2472ea3a067650c330b3a3a1d5529adff2ba9a0d0c473b"
    sha256 cellar: :any_skip_relocation, sonoma:       "1e6b42429bb9650bf8f5b9c05184b0f1eb01a33bd683897d8350845a2230a954"
  end

  # mist-cli requires Swift 5.10
  depends_on xcode: ["15.3", :build]
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
