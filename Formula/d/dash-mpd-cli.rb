class DashMpdCli < Formula
  desc "Download media content from a DASH-MPEG or DASH-WebM MPD manifest"
  homepage "https://emarsden.github.io/dash-mpd-cli/"
  url "https://github.com/emarsden/dash-mpd-cli/archive/refs/tags/v0.2.27.tar.gz"
  sha256 "01a4a513ddebdc9affed8f6e51575df7b7bc2bcdeb785f8e321c84b46c94eb63"
  license "MIT"
  head "https://github.com/emarsden/dash-mpd-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b99abd1d086ada37d7ec0a71660b6226c8671168f62d634286df5c21aae49bb9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0fdcd9132ca030f6acea166e063ce79f1ecd3051bf922f0b605152b4210dda0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7114a3a27fb5dac5d261bd2093ab61ba5a3f6616e248cbe4bd84cbbe40b901f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "f96174fd46c1142421281112246e56f809a785e9aecf5f7cf89e20d4d961b055"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11320e002d70017702eda32585de782d6fb6dd20e479ffa111d37c556e7de46b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ad451329d0d7739fa06ae39c29c1e4e37eec28aa7c344665b5d55ec8d76122c"
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
