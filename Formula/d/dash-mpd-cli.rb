class DashMpdCli < Formula
  desc "Download media content from a DASH-MPEG or DASH-WebM MPD manifest"
  homepage "https://emarsden.github.io/dash-mpd-cli/"
  url "https://github.com/emarsden/dash-mpd-cli/archive/refs/tags/v0.2.34.tar.gz"
  sha256 "1885bec56c1c247bda474f0d85bc6e89ba59cc017c1c63bea9d9830cdbe7d820"
  license "MIT"
  head "https://github.com/emarsden/dash-mpd-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4c81e589672cf6c1c2db541060e3355045a105d702f7ba5244f34aab2dd2b67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e9db6f6a572e9720ab76410d627e2357f918908f9c0518b4ceaa118cc017c9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36b57f31843e3c49264ad2d8508f4a67cdf6d270fb9ef1d9951eaf7e3a915b20"
    sha256 cellar: :any_skip_relocation, sonoma:        "03e1b69ce253932da8b563800dc2ec71537163995a87bea1fe936816b0c468ce"
    sha256 cellar: :any,                 arm64_linux:   "078df1d281ad59cb7d8aaef98c67c26d67ad270d5cb9de7fd1a404fa239c38e1"
    sha256 cellar: :any,                 x86_64_linux:  "b85bba2a02f5b3c56e7fe7847febfc126669144db21f6d1f6a86f02e851cae06"
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
