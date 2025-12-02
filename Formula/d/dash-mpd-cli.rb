class DashMpdCli < Formula
  desc "Download media content from a DASH-MPEG or DASH-WebM MPD manifest"
  homepage "https://emarsden.github.io/dash-mpd-cli/"
  url "https://github.com/emarsden/dash-mpd-cli/archive/refs/tags/v0.2.28.tar.gz"
  sha256 "f30fd28c3a13f9e9236369acbb53bb9cb274ba0fc01cadcb0e6e011a6fd74880"
  license "MIT"
  head "https://github.com/emarsden/dash-mpd-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "89963b3d09f98da55cef65e33ef4778671ab7bd324aae22cb737fd12cbae0e0a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10203358976bdf4efd23f0fea005be9f1dc322a2ce2e427f9c3f6b41561ae34c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9bc4408d72cad8ec18178d7270a5a79b0b9a4d4d2de75937eb3186164697500"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd9679a7c3dff6d4a7a2d2437094b2d95468a58fa2012109978699185dcf23a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be71c9a4e5c78d527300ca08e36111ac459d58d43634f2124cadd2a6dab660cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b902f9b3f0a70d2fe06a9c5f5fd4f98745720562c1421bb6a7038c3595afbb7"
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
