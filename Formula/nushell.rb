class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.60.0.tar.gz"
  sha256 "9b9deb8e42cf18ccf328833a4d051fc14cef0be468afc3b0dbde6657deb9f079"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:[._]\d+)+)["' >]}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "c21a554eb2a7fbeecce61d2af8b46d7fccf4fb061fafbf40bc30f5232e61130d"
    sha256 cellar: :any,                 arm64_big_sur:  "55a730ec582e5c5ddfe8e9fba399a14314a497616f030820a22362eaa74850a9"
    sha256 cellar: :any,                 monterey:       "cd8aa5b6ad2a0b33d2e0433d7faee456095bba2e886210c818af61552ce91ed5"
    sha256 cellar: :any,                 big_sur:        "5fb7a1396649e9c6912fa8db926fecb2b4128162251cbdef1e33a1f54a7887c3"
    sha256 cellar: :any,                 catalina:       "96121aebedca7a9ef255ee85bcd9fac594c8b70e4728d8df6a108f12bffa08ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8e75cdf8761cdb345df6d8e300ccfbe4e64fa0dd7dcd565b2916b658030fbed"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

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
      pipe_output("#{bin}/nu -c \'{ foo: 1, bar: homebrew_test} | get bar\'", nil)
  end
end
