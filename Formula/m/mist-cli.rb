class MistCli < Formula
  desc "Mac command-line tool that automatically downloads macOS Firmwares / Installers"
  homepage "https://github.com/ninxsoft/mist-cli"
  url "https://github.com/ninxsoft/mist-cli/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "aec30c9ff043e17ce0e6dd563480bd8015910ea1f110d4b767522e41e92bc00e"
  license "MIT"
  head "https://github.com/ninxsoft/mist-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "928f50eb19ab4c5c323814adce8d8fba16ecc0b1abd0e729bef9b17cd5d594da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19b7e2cb260545e238222f7b84e289255b738517cd5dd05cc232668666fe893f"
    sha256 cellar: :any_skip_relocation, sonoma:        "b83757aa7976c9656343544be8db0bdfd68ed5c5243c7e7332d4a38392860dd2"
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
