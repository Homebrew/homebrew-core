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
    sha256 cellar: :any,                 arm64_monterey: "2005fb20d0eb5131664f061121c8c6a11e2062ba611e1f9029810071a58f0a9b"
    sha256 cellar: :any,                 arm64_big_sur:  "a4cd427e34215a61808d370269462cf6be11d70d76673d7cf00b99be5337b6ca"
    sha256 cellar: :any,                 monterey:       "8057ed0fcfde4a90ef28c4c1ef1967ac39602d44b9ed318389a7990ab16fcef9"
    sha256 cellar: :any,                 big_sur:        "a0b54eed1421af059d5f80240edf2686b552b7a4c6c7b9da325b2446315458df"
    sha256 cellar: :any,                 catalina:       "2f7e98de2f43c8e4b48abe2df93774cff2da6e98499e66ce9d8efde652ee6740"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a6ff57fb88df052222b40a2487c1dcea6fc630e7f506b5ec433ad4cda28f196"
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
