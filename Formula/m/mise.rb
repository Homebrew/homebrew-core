class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2026.6.14.tar.gz"
  sha256 "2480b1bd8ed693300551113b4dd7771828dcc65651e46edef8ec38e0e37a0fba"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e1d3f23b164035f4a21d43fe32b77900bad2641f1aea4f48dab697a0dd039978"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "63b02392a5a6a16d6831b754b9b05b379935124d700858a23de025e4b99027fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "383501c7218e644d59110d31e35871340f744afa446f82327479dc3fa34a4a5e"
    sha256 cellar: :any_skip_relocation, sonoma:        "a745261341e8f956ea45c9acd7db62a59ba05dea41103715e7ed1eff406ed8b2"
    sha256 cellar: :any,                 arm64_linux:   "6dc57074a055be6a3deaaef67dbdab8ee970e05b268ea8a5053240ad1c942c73"
    sha256 cellar: :any,                 x86_64_linux:  "df9b448ea3ce87bed0b5834de2658ae9bf9824643fb630b3e49ad9b96ec61906"
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
