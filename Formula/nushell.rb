class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.74.0.tar.gz"
  sha256 "7483fabd62e121d93f4a07c154d2f77d0a1f319b6aba996d94d86b157a206078"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:[._]\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6ee27f25e4679b5f5345983462d0744f321e575aeb6ff9b6305357a4e8582932"
    sha256 cellar: :any,                 arm64_monterey: "25914f9c7173e2f7b9d63ba792ac04c97cf71a546b23485e70826b1b956a5f6e"
    sha256 cellar: :any,                 arm64_big_sur:  "67f72e7f625451912467e10947632a8a0c18c51873100f7dcee8dc6dd18f00f7"
    sha256 cellar: :any,                 ventura:        "38e57e9c0747afbfcceefa1ac7eb422ecb00c799231af74a96d1f38b5be092b4"
    sha256 cellar: :any,                 monterey:       "fc675b6da2821ca5e3ad7e37c2a7d56fd3181d06b05241e7b1b93847d3717b49"
    sha256 cellar: :any,                 big_sur:        "2159ca61a7f832aee38b05f7eb5d1091531fbe95f3288198d7a3732ded1788dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b4f0927fd297e8641d4eccc158e21d9def7001ced88d11982d4bf5ac4108e70"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libx11"
    depends_on "libxcb"
  end

  def install
    system "cargo", "install", "--features", "extra", *std_cargo_args

    buildpath.glob("crates/nu_plugin_*").each do |plugindir|
      next unless (plugindir/"Cargo.toml").exist?

      system "cargo", "install", *std_cargo_args(path: plugindir)
    end
  end

  test do
    assert_match "homebrew_test",
      pipe_output("#{bin}/nu -c '{ foo: 1, bar: homebrew_test} | get bar'", nil)
  end
end
