class DashMpdCli < Formula
  desc "Download media content from a DASH-MPEG or DASH-WebM MPD manifest"
  homepage "https://emarsden.github.io/dash-mpd-cli/"
  url "https://github.com/emarsden/dash-mpd-cli/archive/refs/tags/v0.2.35.tar.gz"
  sha256 "f7ff3ff7bffb9d3e5404fed27241c1bad6f11e210180f97dff6701a79db80c75"
  license "MIT"
  head "https://github.com/emarsden/dash-mpd-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "eb8437f41e7303b52475188d6111523fcd07b5128fd0713bf892dafc58b319a9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f97be0533323e9116a537e2ea2ce8c100c01c4a272558b8de6918e5bfbdfa8be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "af026f7b7140f04d80acedd2cb8d22482f8f404c8990564a3deea8e901e49a86"
    sha256 cellar: :any,                 arm64_linux:       "21e3988e870a2eef884658569139416993fc5b09ac39bfc4ec1b489ad7d2d54d"
    sha256 cellar: :any,                 x86_64_linux:      "d186e07b0ccc145ccf38d0f3cf706a9e71124372351b23b56e3660ae7595f4fa"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build
  depends_on "bento4"
  depends_on "ffmpeg"
  depends_on "mkvtoolnix"

  def install
    ENV.append_to_rustflags "--cfg reqwest_unstable"
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
