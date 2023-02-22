class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.76.0.tar.gz"
  sha256 "952d2f1dd2543eb823dcfc9edf83f0cbe90f0b9adcd8d8dd37f44a9c21c83287"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:[._]\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c463d9f28959a206fd96e5f70a08ad4f3b036eb13169d9ac8a074552c53400bc"
    sha256 cellar: :any,                 arm64_monterey: "47a64ea672c98e77952eddb2e9078becbe5e1a96b741f409a2ae37592724a64f"
    sha256 cellar: :any,                 arm64_big_sur:  "fc45f5f65d69dd3b12f81f2fc45599edd82685ea8586d2ed52978a1e7a748895"
    sha256 cellar: :any,                 ventura:        "0488dabccfd1cff90bcb9420862447f718dd4ea748b4048c821b24acd24566e7"
    sha256 cellar: :any,                 monterey:       "b1be2fcb6c3a3da673d05caef30bdc49755f3f97b3b3424c9263b3b39a73dcea"
    sha256 cellar: :any,                 big_sur:        "c308ddcdbddec5d49012939f3396d49cfc09f07cf72a7e9311858acd91d2150c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e75111e66011b3f3e1c685a668e612424670fa5f62b3c2c4786f8d3af26eb3e"
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
