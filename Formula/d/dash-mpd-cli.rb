class DashMpdCli < Formula
  desc "Download media content from a DASH-MPEG or DASH-WebM MPD manifest"
  homepage "https://emarsden.github.io/dash-mpd-cli/"
  url "https://github.com/emarsden/dash-mpd-cli/archive/refs/tags/v0.2.32.tar.gz"
  sha256 "8df3b56323ff305784e5807c1195877066738bf9476dccb843aa39d1b8072bb4"
  license "MIT"
  head "https://github.com/emarsden/dash-mpd-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8c18fa1e0c57953c4d12049080927e277a930a5cad4b632f933497692889c0f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b4fe68d726b2d48e5ebfd084c09ba09fe1a7eff7fc0252023603390b99163a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45bdd5931e051df6fad8c2759646deeb23bed059f4e2fd2158a8f873d5fee030"
    sha256 cellar: :any_skip_relocation, sonoma:        "2684596559d446563fddaa86f68107bea142b51e3c313eaad68f75d91495d911"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f7b1243a1e0d4482b5c6b822db3af20dae0383965db43af7e401f7eb1f38b05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0ba2952e73397b6376ee8537a27c5384caf342e8d7005e98d8fd9c2e86e9ecd"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build
  depends_on "bento4"
  depends_on "ffmpeg"
  depends_on "mkvtoolnix"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    resource "testfile" do
      url "https://storage.googleapis.com/shaka-demo-assets/angel-one-widevine/dash.mpd"
      sha256 "4fb9ea292aba0db94ddfe8c941b8423d98decb51dca851afbc203e409bd487d4"
    end

    dash_manifest_url = resource("testfile").url

    output = shell_output("#{bin}/dash-mpd-cli --simulate --verbose #{dash_manifest_url} 2>&1")
    assert_match "video avc1.4d401f       |  7493 Kbps |   768x576", output.chomp
  end
end
