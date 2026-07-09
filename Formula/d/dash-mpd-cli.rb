class DashMpdCli < Formula
  desc "Download media content from a DASH-MPEG or DASH-WebM MPD manifest"
  homepage "https://emarsden.github.io/dash-mpd-cli/"
  url "https://github.com/emarsden/dash-mpd-cli/archive/refs/tags/v0.2.33.tar.gz"
  sha256 "d112b1220e64594d08c441cb13376649bb5324ce3c5877cc0c4dfcb4a580831b"
  license "MIT"
  head "https://github.com/emarsden/dash-mpd-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "635259c5f7c059bb33fe11896c40c2ccea05ec98043705ba6beffc7ced16fc99"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f47a20ddbbf8932bb9f303a9ab05a4861304a745d5ead14726bcd3a6e0845272"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96ee0a0eb8229033563c710c8f02b9ab135deea4a0075d105a9cf7ef63fcb165"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f3684e1ff58fa43db507556240c72d1d6891b031b2069816207dc8d6e77b353"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8de9046fc59915ca53cbbbe99c49d26c861957679c5fa5f43dfba3b25cc9ad26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19f8c3ea06263bc76ecd858129a517dfdacc67fb1a9c1acf98ad4026739b2009"
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
