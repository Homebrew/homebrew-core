class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.82.0.tar.gz"
  sha256 "587847feeb9fc06eb2a9da5ff05ffea5238fe5928ebea944c042838d8ad136e8"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    regex(/v?(\d+(?:[._]\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a0f940a5428493fed8bda6a17f69ec2ac8cdfc43184d5f850f3968991db08d64"
    sha256 cellar: :any,                 arm64_monterey: "80f18535bc0cb1cf503bd9602133c7bd2b5476a17d4fa4fe687371f461d807db"
    sha256 cellar: :any,                 arm64_big_sur:  "a4d5f3bf87b85c7d46dcdd7e09eb4f16865b5dc263e32dc455dc1e6a1d131027"
    sha256 cellar: :any,                 ventura:        "5fe4d1ad3399185d1fc7aa61a1f8bd0e59ecdfb24975340b8fa1860e184d5cde"
    sha256 cellar: :any,                 monterey:       "82108dbb8b4cc0dfc98d94a0687ab6a505cc27dee539a38e6b02307af2e56922"
    sha256 cellar: :any,                 big_sur:        "a5b076f5cd29b52efeab82f0a9151e190bae402ed893a86d7a03fdfd254ee07e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a89754f22110cc032311ba481ce4556807a8794cb080d910a8970d07b2c0f18"
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
    system "cargo", "install", "--features", "dataframe", *std_cargo_args

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
