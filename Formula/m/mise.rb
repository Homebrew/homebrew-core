class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2025.10.15.tar.gz"
  sha256 "153c8e391d700d6c4b95a2498ff4bd924935cd826d358fa08008097a355dd604"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e06f594eb4ae26b1a7f98d4ec164e2fb5590bec2887dc18206159b6532c244eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1f7fc7e543cb18c445db783e21aad9222ac765038c94a5cb77f1b75f3ee4743"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "806d769d604a7572a9e7e62cc1bf839370b191071c445da016b740cc26156024"
    sha256 cellar: :any_skip_relocation, sonoma:        "88c80381d81eebe3106cce5e05d4e6f86a4c483d42fe5b33f46a23c522305d7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89f6c661b944d6ce458b55469e06e2e079702a48d95fb1d15cfd64670296914e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e15982cb5614796da218784f6c585ae07c5f46aef150b081281f305dc2209e1d"
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
