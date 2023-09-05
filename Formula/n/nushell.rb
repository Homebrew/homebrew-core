class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.84.0.tar.gz"
  sha256 "483211c44bb40ca6199b52824ea0a935da19d6a40259c4e27c29ae1e3b3be2a7"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    regex(/v?(\d+(?:[._]\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "94241cd83053f04b068f39237ccfd1168815a13760d86d140a712c9df1dbfb46"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6f0da3151f0dd3dfced8bb1f783b4e1edbc37b1085bfafa067d3e41f6d0d51c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "77be7d6093254ab954c1a95b3140db2687be574abacdee783f043cdf5068065d"
    sha256 cellar: :any_skip_relocation, ventura:        "e04307a11f1b1d6cb2ae6755251373fad92f068da1403fc279f15fbf2c6d25c2"
    sha256 cellar: :any_skip_relocation, monterey:       "d348c3d2fbc7dba8e7ea3490d093e560d372dd2d11d632207520009f4802cffc"
    sha256 cellar: :any_skip_relocation, big_sur:        "d4d85464bc242cab7ecafd018957f07f471ddf2d07ebc9d229646f29856c33c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b541aa76f436e6598fbe44eec47ee403cb6c63f1f0d11ed8e144cf091b1e3b50"
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
