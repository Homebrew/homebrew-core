class Mist < Formula
  desc "Mac command-line tool that automatically downloads macOS Firmwares / Installers"
  homepage "https://github.com/ninxsoft/mist-cli"
  url "https://github.com/ninxsoft/mist-cli/archive/refs/tags/v1.9.tar.gz"
  sha256 "79f259ff10a56f7d01a43fcd9525680f237a0955631cae54dbb33c924f0ddc54"
  license "MIT"
  head "https://github.com/ninxsoft/mist-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ace98c851f364b27361f705ea322f9666128dcdae270c642b61f199ed951bed9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0e4b84bef799cb4a99f0360c9238b890ac4e1262e42d638fcbcfb9108ec93048"
    sha256 cellar: :any_skip_relocation, monterey:       "95b39064f9cbc917aa44c96306673d03b449f762177112ead711dcaa31ae0593"
    sha256 cellar: :any_skip_relocation, big_sur:        "3aa5c93b6d4fd30b1f540984df272ef17acfd6fac15f5d2e0afd7c228e2709bd"
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
