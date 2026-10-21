class QobineWeb < Formula
  desc "Server and web based player for Qobuz"
  homepage "https://github.com/SofusA/qobine"
  url "https://github.com/sofusA/qobine/archive/refs/tags/v2026-10-16.tar.gz"
  sha256 "826ddc36d1f297b7cd9da4fb542361eec5b321364378290a8c42c6b46ffb63cf"
  license "GPL-3.0-only"
  head "https://github.com/sofusa/qobine.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._-]\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dec457c6c77ff19b9bc39e115f035a19ef8273b4ead352c53e59493bdb986107"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "69e23ea61e965cb2e6b917ba984376ca3e4f1ede3aa74d224f1fc4b9cfcc1155"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7a92eec18377eeb3a5aee9d91452bbe43de5597cf6983f04920aee51c6c77437"
    sha256 cellar: :any,                 arm64_linux:       "9031d852164349b20e5de88e01ec96cc90fcdbc133c8a07ae0819cc5256dde1d"
    sha256 cellar: :any,                 x86_64_linux:      "c17c81ccd7a39f4cee6ecf0deddc115b01492957f7b771ed843bd22824a046e8"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "alsa-lib"
    depends_on "openssl@4"
  end

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "web-module")
  end

  test do
    _, stdout, = Open3.popen2("#{bin}/qobine-web login")
    assert_match "Login to Qobuz in browser...", stdout.gets("Login to Qobuz in browser...")
  end
end
