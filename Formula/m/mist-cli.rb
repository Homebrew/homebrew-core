class MistCli < Formula
  desc "Mac command-line tool that automatically downloads macOS Firmwares / Installers"
  homepage "https://github.com/ninxsoft/mist-cli"
  url "https://github.com/ninxsoft/mist-cli/archive/refs/tags/v2.0.tar.gz"
  sha256 "834783a9dac65aaea99a1ba3b12028a032e052d28f73a7d9e4bb363e8b1332ba"
  license "MIT"
  head "https://github.com/ninxsoft/mist-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "962bc31fe85de902df3a0ca40839be5e472ccb2179158fb1b38c3642ea9fcf9b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "761d22cdc4fbc01c61623ff27f869ecb04d2601dd5bb985643994928577d7a91"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ec2ab486c501840c7533bd68b43606133c9f98101e25fb4e64db7cd47e2aa75"
    sha256 cellar: :any_skip_relocation, ventura:       "3d3f743e3c294efccbf6432584602f1bbdd8903e9e15f9c438b994661d5a1b49"
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
