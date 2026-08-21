class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2026.8.10.tar.gz"
  sha256 "b1944d2fa08addbff5b31ba1a6435e787c4d10b0e7a146cdb5510e99c017b5d9"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5846c63ab138356d99b8bf916450d90626f9644f6b904f08ef18005a55c6628"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ae75812ab93963d7c94f507c0678237ee81772530f583fd456264a6604f44c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2344210401d69f1284e31a05aeea3af80766242fa8f0c690406123f31ec08ef0"
    sha256 cellar: :any_skip_relocation, sonoma:        "d7bc6bf7030081cd63856d111528792df358df3a362df1326b28592d2aae47a5"
    sha256 cellar: :any,                 arm64_linux:   "dc35b097fa0dd3c47deae6a4df16a91646412d8221d0cde37283124f1aa537e9"
    sha256 cellar: :any,                 x86_64_linux:  "25fb3614c3c0057de1c767908d343cffb46c3a0e01b72b8638d06e188eccea07"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "usage"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")

    system "cargo", "install", *std_cargo_args
    man1.install "man/man1/mise.1"
    lib.mkpath
    touch lib/".disable-self-update"
    (share/"fish/vendor_conf.d/mise-activate.fish").write <<~FISH
      if [ "$MISE_FISH_AUTO_ACTIVATE" != "0" ]
        #{opt_bin}/mise activate fish | source
      end
    FISH

    # Untrusted config path problem, `generate_completions_from_executable` is not usable
    bash_completion.install "completions/mise.bash" => "mise"
    fish_completion.install "completions/mise.fish"
    zsh_completion.install "completions/_mise"
  end

  def caveats
    <<~EOS
      If you are using fish shell, mise will be activated for you automatically.
    EOS
  end

  test do
    system bin/"mise", "settings", "set", "experimental", "true"
    system bin/"mise", "use", "go@1.23"
    assert_match "1.23", shell_output("#{bin}/mise exec -- go version")
  end
end
