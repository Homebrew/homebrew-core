class Mist < Formula
  desc "Mac command-line tool that automatically downloads macOS Installers / Firmwares"
  homepage "https://github.com/ninxsoft/Mist"
  url "https://github.com/ninxsoft/Mist/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "49a362396014460847b7b04c2f6347c10da73e2d0348543ac26d78ac30cd9f6e"
  license "MIT"
  head "https://github.com/ninxsoft/Mist.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35375786bef6d615bdcb87cb580f18dd0e3825a48eb297b6e18e8a4de0b4c25a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ffcafe421bb04ffa7b4509ae724f900d11a894891e27252398cc198ad330aa89"
    sha256 cellar: :any_skip_relocation, monterey:       "a385b61b7c5db3f570ad7f004d63fe16e87f8d9e19b5cf12c648f10cdb544f18"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab75aa8de44adc4fd72be7d70feb92eced0603238c209d0461c25e2341b1cb4e"
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
