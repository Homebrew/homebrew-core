class Mist < Formula
  desc "Mac command-line tool that automatically downloads macOS Installers / Firmwares"
  homepage "https://github.com/ninxsoft/Mist"
  url "https://github.com/ninxsoft/Mist/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "0b1ec7fed7bbafb3221656376bf69407fe602ad4cdb938089d8cf7c585112394"
  license "MIT"
  head "https://github.com/ninxsoft/Mist.git", branch: "main"

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
