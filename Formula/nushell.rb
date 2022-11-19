class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.71.0.tar.gz"
  sha256 "0f3a279ead004c86c44b6c9991e9e838b819dad23d65add7250a9691ad29f209"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:[._]\d+)+)["' >]}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "51d415402fa98230d461bce3bca57d9076a98d13debaca60d6012bc13c67c177"
    sha256 cellar: :any,                 arm64_monterey: "9ab3431541a906e70dbc6ff6199bfc55b60f167020586be542c6c546ecfe6bef"
    sha256 cellar: :any,                 arm64_big_sur:  "dd19c564a15041fbdc9f2c033060beb0657c042c65eaca230738c03be44a5013"
    sha256 cellar: :any,                 monterey:       "d8c402110fe653332bae86db9baf0c0404e36bdd0b75ac7f08f5520b9d6ff770"
    sha256 cellar: :any,                 big_sur:        "bd772eb91d3d4e8f10be772ac58b06913640535147e122e2b28efe31e621dba3"
    sha256 cellar: :any,                 catalina:       "b9fe355f40ef6c81a55e08e12fb7b2d5403537e370d428a1ec8c3f7c64138f8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40a844add05099b069cff54b043875f65ebc01bc7bc719ba06393e678c90778a"
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
      pipe_output("#{bin}/nu -c \'{ foo: 1, bar: homebrew_test} | get bar\'", nil)
  end
end
