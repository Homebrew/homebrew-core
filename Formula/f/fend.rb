class Fend < Formula
  desc "Arbitrary-precision unit-aware calculator"
  homepage "https://printfn.github.io/fend"
  url "https://github.com/printfn/fend/archive/refs/tags/v1.5.7.tar.gz"
  sha256 "864059155044a94d4b9d2e37c763f8c58b19afa5db3f8f9ed1064bdcc4732f4e"
  license "MIT"
  head "https://github.com/printfn/fend.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "052301362c6976fe31505c6e34b0b56a68caf8b8435b4815350f84922d91700e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d792141c5622e31c627e692a372614af2afed3676794b737e64ee34f7f63ef2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "220845eb67fca114f055d9a5389d0430561f01bc30be37e26ebd5cb111312c1f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "49aa56425353946fa664971fb5814d2bb41e179f6283e59d8d0d5ffd43fd338a"
    sha256 cellar: :any_skip_relocation, sonoma:        "699553646682089ada667cac9ac23df470b6270155343f67fd6145686ede8145"
    sha256 cellar: :any_skip_relocation, ventura:       "fd3b49c8e097cfa9a52ccb031eeedc967d2481f53167d54817fa5e6a45924bb7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2df95ea2f133899e8be58f2a7d38684949283bcd84874897b28e97ab94ab34ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "464a37e75cbf4c14a31e4aedf32ef3ae25087be09b7eaa4f191db3e7eb4a6d91"
  end

  depends_on "pandoc" => :build
  depends_on "pkgconf" => :build
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
