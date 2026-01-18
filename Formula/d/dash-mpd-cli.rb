class DashMpdCli < Formula
  desc "Download media content from a DASH-MPEG or DASH-WebM MPD manifest"
  homepage "https://emarsden.github.io/dash-mpd-cli/"
  url "https://github.com/emarsden/dash-mpd-cli/archive/refs/tags/v0.2.29.tar.gz"
  sha256 "53600093f9c67ae87cdc0118a3cacfd005021a9b9a660ad6ae4381815b76a2c6"
  license "MIT"
  head "https://github.com/emarsden/dash-mpd-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63456767f7a3e254fbcf8e7a8c8fbf38e9f350b5c0d21ca0e6ce7638950d5000"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c40ad5081263c27014e5967a5b7946fcac97779503ab3c009bd1b5488af31c2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "356a3733de32d61f1ddfd2c22aecc23789e3f62609768b4cc3fc5e9c2797fccc"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee7c18dc22ef8c9d52d0596e290402cb6e4f2651ba56fa874d2b93cc5183ada9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b95e640c708a96738e126eccd3882a5a427c0e3203ae6c159d0371ef7033c778"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b433595fc168594891171dfbc82127d8027985897553513bb0950f318394d95"
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
