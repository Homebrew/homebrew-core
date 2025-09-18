class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2025.9.12.tar.gz"
  sha256 "83fbd80c12f42a6080755557406067b557d2ce2716fd160e3eecff337e440c1e"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "29d9aab7931cb9e8f24b10693b3c866da0d6e0cc323ea08a2614e76f3bba9826"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c324ecb656e6923c0df1b22a1c80c5ddb84e8c86701df4ca6a20852252ca908"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40903d636928123314c847293b0439a4d57e5e8ce7e94e11738577c5b58b26a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "6497240d2bc7f843814c4628ec6fa559692ffd42b6437f2c026f649da9763dbf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1835ec6666f3cc34b07fde709d8c53d61f5ef28b2b201e77ac335227c20e2c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac64d9c3d01f081b068e1e2e216adf34b1ffbb90506d991e814eac07c44f18aa"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "usage"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
    man1.install "man/man1/mise.1"
    lib.mkpath
    touch lib/".disable-self-update"
    (share/"fish"/"vendor_conf.d"/"mise-activate.fish").write <<~FISH
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
