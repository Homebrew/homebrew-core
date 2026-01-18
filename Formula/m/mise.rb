class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2026.1.3.tar.gz"
  sha256 "552e7879ea282baf93890cf95e6f38a68e20fd9e8bfb3349fb56bba68f36fde6"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "23b4b52f2a47de3b37041bc3a97302368b89abfea92f96c206756bbd93ee876f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bbe6900d676bb7c0f5d4f2a0d984fc55673fb494eb456182c39e1acaf658fe25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "996923cc84b60f96aa71e96cac65baaeae26ec164131222a9a27980e33b87ec5"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3625de6bd77c58442c7c15a60bb51be368968d86cf5514bef39df31c8cd16ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce50c4420102a44bbc260e4bac5f30efec0858a3b510ff0247b7eb46674122af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a50ecbce9552f5034afe2b006ff6d3e5ffd914a4ae5419f8ba7be85972bece4"
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
