class DashMpdCli < Formula
  desc "Download media content from a DASH-MPEG or DASH-WebM MPD manifest"
  homepage "https://emarsden.github.io/dash-mpd-cli/"
  url "https://github.com/emarsden/dash-mpd-cli/archive/refs/tags/v0.2.30.tar.gz"
  sha256 "7e917bf7187e1dfd45e5c77ad388809513ddf255c8130ca665c5801c0a1d8a1b"
  license "MIT"
  head "https://github.com/emarsden/dash-mpd-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d4d8586708ca81d161d982e5bbc81bb0e179092493fd004c90f2aef0f206da0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d764395193ca40560c1eab2af6276cc22d1224c884c790c0347f678f8a11bfc5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "154033db33172ae3ff71a93400bee3ee2ca176e0ffa79f3d4f23213124bfe3c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "72af24e2378b26ff327f1bf8adc0bccaaf3eff85efb8064e998ee37c8c219976"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "855a93729ac7ef08af58d70db7fac7b949f2972066f4747dfc185f662ab599d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe3b0879acf0652c897668abc3295f1e672a72b3c342c130f55dfac698caf824"
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
