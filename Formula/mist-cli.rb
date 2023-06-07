class MistCli < Formula
  desc "Mac command-line tool that automatically downloads macOS Firmwares / Installers"
  homepage "https://github.com/ninxsoft/mist-cli"
  url "https://github.com/ninxsoft/mist-cli/archive/refs/tags/v1.12.tar.gz"
  sha256 "1001d2913062ec2ba6c55732b7bb4eeea53986ddeb23e94a07f44e5dc177accb"
  license "MIT"
  head "https://github.com/ninxsoft/mist-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bd38464c0250f0012903da27695ca5bd88d80ded74956e7dc9823b4a7f173752"
    sha256 cellar: :any_skip_relocation, ventura:       "501a9c0552f2f5a5bba0b6274eb8e3f38169c932631db752abd46d7f46575af4"
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
