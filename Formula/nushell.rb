class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.64.0.tar.gz"
  sha256 "7adcc49bca0748dba680a2e118e158faae7bc14fb2e32b0056866d356b48d879"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:[._]\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "af727ec5e245d21310ee0f64e02f14bf93339b9b884ca090b82175f944faa51e"
    sha256 cellar: :any,                 arm64_big_sur:  "2fb221f4c88625b76b0dc5426d618f98d1cb82f00fd69edbd00bd6af8e92e620"
    sha256 cellar: :any,                 monterey:       "0f9548e282f09bb21b9eae6dcbe9c1e85dbef632501ae2c1bfd312b8b210af86"
    sha256 cellar: :any,                 big_sur:        "c35bf6fd190df289d0206acfc018acc04d95633ff03d5ee91ead0c531d866cc7"
    sha256 cellar: :any,                 catalina:       "fa19be9b0f4b265aeef90aafd9a1018c2ac8ad0290ad68aa7b85995bcce446e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02232cb0bdb6296a62a590e9f5ab29996fba68f6858a029fe129ed6faffdd040"
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
