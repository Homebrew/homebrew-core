class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/refs/tags/0.98.0.tar.gz"
  sha256 "c77fd63c4a5f2d35f7dcbb3e9bd76dfaa23acc6bc21fb1de4e7a4a94dc458839"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    regex(/v?(\d+(?:[._]\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "68edaba8030668458159db075df2f2952d8965b18a7c0b547a0ea4f289fb7317"
    sha256 cellar: :any,                 arm64_sonoma:  "b0b3d7b2f63b8d0e6b5d56df4e2d5e7a05e018d6543ddc01eb117fcae4b9b208"
    sha256 cellar: :any,                 arm64_ventura: "9f8c041a21202b12617ccdd937d10f164b39063b1f44b2d5b809e9a649e8181d"
    sha256 cellar: :any,                 sonoma:        "950cb194c3064eba43ac544a7c07104a2cbe6da95c6fd9819744f7227df62629"
    sha256 cellar: :any,                 ventura:       "12176209dfcabc48844aa231d6cbe7438b31aec53b66584d9806f497566d1e7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8107eab035b8f04ffa2b9af6a21c5ac52d35688dcecacb73769a3223b5aa26f4"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
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
