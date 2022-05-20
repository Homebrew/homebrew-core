class Mist < Formula
  desc "Mac command-line tool that automatically downloads macOS Installers / Firmwares"
  homepage "https://github.com/ninxsoft/Mist"
  url "https://github.com/ninxsoft/Mist/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "49a362396014460847b7b04c2f6347c10da73e2d0348543ac26d78ac30cd9f6e"
  license "MIT"
  head "https://github.com/ninxsoft/Mist.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0874f6cc33272436447fe0f363348d4b9170fef67a5913373a0d6ed8f5feee9c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "54eca06d7652fbb198304ca71a7b12006dcaf3ca914c6b84f938b8bc24e9ec73"
    sha256 cellar: :any_skip_relocation, monterey:       "55847742460e3637d910a4f24e7e5574a576ce4db931e1739abacb3179a10c8e"
    sha256 cellar: :any_skip_relocation, big_sur:        "71e2ef77f7c6bd38ac1691b65b754465a0513fe087f4d7d2f1267d4a322774cf"
  end

  # Mist requires Swift 5.5
  depends_on xcode: ["13.1", :build]
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
    shell_output("#{bin}/mist list --quiet --export #{out} --output-type json").strip
    assert_predicate out, :exist?

    # check that it's parseable JSON in the format we expect
    parsed = JSON.parse(File.read(out))
    assert_kind_of Array, parsed
  end
end
