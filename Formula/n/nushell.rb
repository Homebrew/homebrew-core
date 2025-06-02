class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/refs/tags/0.104.1.tar.gz"
  sha256 "3dafca8bf892f5a2afaac1122a88a7eb7f22a0b62ef901f550173a11d5cbdf6e"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    regex(/v?(\d+(?:[._]\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9191e5e3539b7799579f9e1fa7f163345cbf52703b9ca8ee4fd189085b179708"
    sha256 cellar: :any,                 arm64_sonoma:  "add921e6f8a870f6c8c6dc01f38a2f327628ef24788dfd0a73bfb45207eac1ed"
    sha256 cellar: :any,                 arm64_ventura: "d8300f09403ad05baba83f8ca575fbfee3c388408d1c0d3d7aa86be515b9ddb4"
    sha256 cellar: :any,                 sonoma:        "11d69ebbd1f21e5f616c56328632c2ed00b99c1d7520838a105fccfcd675bcb5"
    sha256 cellar: :any,                 ventura:       "69a0d37792883f4178104518fb71c18fc3aa6d5131440373485fa41f2446472a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3cfcf307e7c7b556051c2fca9773d5ca75287b5e6d04745a9848a2fb119054d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc0c51dbd89369c39ee85864c6733e19bd604eabf77a171fa211d131d1e4e1ce"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libgit2" # for `nu_plugin_gstat`
    depends_on "libx11"
    depends_on "libxcb"
  end

  def install
    system "cargo", "install", *std_cargo_args

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
