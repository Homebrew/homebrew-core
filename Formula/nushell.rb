class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.66.2.tar.gz"
  sha256 "548668fe0e746cb068443b7701829e1839565e30aa5faa20c5481d0ead808045"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:[._]\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f796dc5e814500c4f725934a26f677f12fe3c61b0a0158ef09c0e32431151fc1"
    sha256 cellar: :any,                 arm64_big_sur:  "d6a46c91d726ac3d6cba5a2a89e203fb59dbfac83dab86fe73a4ac7084e0c45a"
    sha256 cellar: :any,                 monterey:       "b6ad3c6f6b837679818c8b4d1c36b4f603265e91a39ca24036db09f681d41a27"
    sha256 cellar: :any,                 big_sur:        "9cc4641f91a9c1b83bd0050b5f77b7654519c78dd78690b8736c7941c483e878"
    sha256 cellar: :any,                 catalina:       "dd05535d9f34d9b0fb559bb13f10973b13edc8243f99006969c45a6c514b3a99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61b8ad55599985cd3e68012006e54bbe64ae6759fda74a7cbc1076550fa1d641"
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
