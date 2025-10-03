class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2025.10.1.tar.gz"
  sha256 "30c7e11774ef85e237abb8e9718c36fd008a689f65ec6e80ff4df93d6d1118e5"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac3604d6f0c75065f1bd7ef32834a97fa330bcc5209810496c0593044e3a818a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1886cffb0c3183bb656e8a468ebeb7de2b21cad9416ed7f917a770ff69d3a12d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e0b7dd6cac273e2153dbb997ac2e81879ec57cb3ed20e96b7dec4e1a76ffc3b"
    sha256 cellar: :any_skip_relocation, sonoma:        "b3b138a3bd227100298e6d94477d8d7dc31876d6954b307771f4a2112ce5e4d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ebbc05b41f1a1008a32672b5981bf3797dd376024da83727eadce8fc8a6fa9f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "721b0878393ab6579ca6f8e3a62451a0d74f2aff37fd97ca2c4673325daa1e93"
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
