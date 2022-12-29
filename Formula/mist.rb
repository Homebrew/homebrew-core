class Mist < Formula
  desc "Mac command-line tool that automatically downloads macOS Firmwares / Installers"
  homepage "https://github.com/ninxsoft/mist-cli"
  url "https://github.com/ninxsoft/mist-cli/archive/refs/tags/v1.10.tar.gz"
  sha256 "c40ae66b84ab20998794a2e6d5e94e71afc65a4b3f9b4417babb2f34cd09608b"
  license "MIT"
  head "https://github.com/ninxsoft/mist-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c577efc7fb3bda73e9d5fba24d1f898f270b92e101a9820a9f5bf446eee9b8c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8eccc9c06cbc334be6e0c10734bfc27ff3407ca6689679b588c51356bba87712"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "034e6dcd59c97041a1033abe1c6cf69331baffeb13623f9209357d55683edaac"
    sha256 cellar: :any_skip_relocation, ventura:        "ed30c419439e153bf435bec3daa359145d46c5ce76218deca63b7751a0b61238"
    sha256 cellar: :any_skip_relocation, monterey:       "04c3a513218e8f1ce6bf5864476417a2c9794684a0226ec61848c30949459542"
    sha256 cellar: :any_skip_relocation, big_sur:        "cc83e0f359cadc97a5c48cbc7e6c57634187d4a7d16a675c4158339ed196df96"
  end

  # Mist requires Swift 5.7
  depends_on xcode: ["14.0", :build]
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
