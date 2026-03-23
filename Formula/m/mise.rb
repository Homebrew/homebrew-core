class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2026.3.13.tar.gz"
  sha256 "bb769fcae08a763190aa6f119d763f0bdb1523498b7fde053224956eda588339"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57d75f57a60d3355be89f727f9666d8fc9bddf56468dc175c4c55a04fc0d2fa6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ee2a4ce68461a1150e9e607dfbc498ba9ddbf12b67e54081e5bd3bb642a4173"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2df211e4a453679b9702b392838b2e9d7cef5c233ee1a6613f60d2dde6b22624"
    sha256 cellar: :any_skip_relocation, sonoma:        "832bf68eb9e441023877c3e8cd9f07d87c89a61951aeb684717363f60d5e8605"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6b35b3f9bfd305441d65fdb243e0be505939a097b525fe06c510e57dd5de5be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bbe013e5fd812dba9362c25e2f0581de294b981121570da63f0503618f2288d"
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
