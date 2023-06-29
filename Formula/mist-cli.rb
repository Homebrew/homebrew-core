class MistCli < Formula
  desc "Mac command-line tool that automatically downloads macOS Firmwares / Installers"
  homepage "https://github.com/ninxsoft/mist-cli"
  url "https://github.com/ninxsoft/mist-cli/archive/refs/tags/v1.14.tar.gz"
  sha256 "b1559c343b7de4d7eb898b83ecf44e9597c33bb78b958a7d8a01f314de03ee12"
  license "MIT"
  head "https://github.com/ninxsoft/mist-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3fcd7f784a202c23673288b93b1ff4eea959ca299d4c32c54fcebd937c9b810a"
    sha256 cellar: :any_skip_relocation, ventura:       "c60d4abc1ad70532af6ea195948a2f5ec0a3c1e2117eacd5471ac6ae8526a55d"
  end

  # mist-cli requires Swift 5.8
  depends_on xcode: ["14.3", :build]
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
