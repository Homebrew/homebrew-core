class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/refs/tags/0.88.1.tar.gz"
  sha256 "19f5a46799142117f61989a76f85fdd24361fe9e5068565d7fff36b91a7a7a39"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    regex(/v?(\d+(?:[._]\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "952e793b589c0f84f58c48c28686e7d4340e70b662ce43147884a8adc571c059"
    sha256 cellar: :any,                 arm64_ventura:  "de1184e3ca583e86c68235c3d1027c4be1bd6f58c61edb8973eb26732ac0e127"
    sha256 cellar: :any,                 arm64_monterey: "5ecce96197b58bd1146dde4dfdb52ac35f6a97f1697b557207f5b327163e40cd"
    sha256 cellar: :any,                 sonoma:         "0e988e4e748de11d02ac602c19611a2f543b3841b06b42d664afc23e54cc6925"
    sha256 cellar: :any,                 ventura:        "1feca8f3be74d1a17e8e6fb5dda8c58ae6284266cf6e4bd255dbe25f07ff615e"
    sha256 cellar: :any,                 monterey:       "131936d966125ad167a7043655fce4fbd3db85e6ca0429d68254bac424efe40b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3182d2018a2268978ab9340aed4722e427dfeccc93c670a09c34c0098ae89922"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libgit2" # for `nu_plugin_gstat`
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
