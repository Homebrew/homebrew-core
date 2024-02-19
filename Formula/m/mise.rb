class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2024.2.16.tar.gz"
  sha256 "5584f9804b300303f98bc423d8a257433e21f099976be353188bf6272c8029c5"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cf2658e28f73f665dffee065fe2d5d937428b84a946045729261eb1d909097ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b33461f6e4d3dec5874d3cf33ba2f50c56405a4a1614702413714ece30aeca9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "118252faee191298da1484d2a0e9fb4e9db88a02616b73a08f060941332d840f"
    sha256 cellar: :any_skip_relocation, sonoma:         "ccbcdc667eb9ebfaea72708a299d4377d426c6bc269476cb8517f1a7e2fd30a0"
    sha256 cellar: :any_skip_relocation, ventura:        "5c8ca4220d2ad61e1f55a618a2060da4db64cde0fcb70a09aa4cddee48f35766"
    sha256 cellar: :any_skip_relocation, monterey:       "264e93049b3665c1068f693929fb53e7015ce8b9811080ecfa78b6a94721b2e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "503709469df1ccf64a42386bd933d8f307b9c52d3e2bc77106ed96bf06c369c8"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "man/man1/mise.1"
    generate_completions_from_executable(bin/"mise", "completion")
    lib.mkpath
    touch lib/".disable-self-update"
    (share/"fish"/"vendor_conf.d"/"mise-activate.fish").write <<~EOS
      if [ "$MISE_FISH_AUTO_ACTIVATE" != "0" ]
        #{opt_bin}/mise activate fish | source
      end
    EOS
  end

  def caveats
    <<~EOS
      If you are using fish shell, mise will be activated for you automatically.
    EOS
  end

  test do
    system "#{bin}/mise", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/mise exec nodejs@18.13.0 -- node -v")
  end
end
