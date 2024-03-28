class Fend < Formula
  desc "Arbitrary-precision unit-aware calculator"
  homepage "https://printfn.github.io/fend"
  url "https://github.com/printfn/fend/archive/refs/tags/v1.4.6.tar.gz"
  sha256 "88fe4abf2caf96241a2964f510fd8801ac22f5c1511a4817361e676e931b0ce0"
  license "MIT"
  head "https://github.com/printfn/fend.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dcd9a91024ddcc24752c06208b69db49770bd442fcc1b6e3703c77cd70e2bbad"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e17da28f1c828f53598dd26e5d03a026ae7bb6e91f0f78b660a1d40f963c9632"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d71ff5b3029a277b9730ea2f62e332844f804c92e6d2dbd5a88b099861e2013"
    sha256 cellar: :any_skip_relocation, sonoma:         "392585774c86e00074aa0de655f1ec304478af61c6c3ee876bb194882ca52d45"
    sha256 cellar: :any_skip_relocation, ventura:        "e4781d07249b0364061665eb0534a0f9505847ee67fbc30b58bf3dda25c585ee"
    sha256 cellar: :any_skip_relocation, monterey:       "fc25a4ca3a345198105e033f041cf06d20a4114231da885b01a4c4e81816212d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "861a14b1c5a86cd2e5d7c11d922da45a2e52794549506b05da569c3b13880ef8"
  end

  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "cli")
    system "./documentation/build.sh"
    man1.install "documentation/fend.1"
  end

  test do
    assert_equal "1000 m", shell_output("#{bin}/fend 1 km to m").strip
  end
end
