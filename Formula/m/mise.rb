class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2025.10.2.tar.gz"
  sha256 "38c75cf3cd6ff4854c66ffe242ffc69771f76826e567cdfc665cddb3c0b15f0c"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f56874dbcb4dd2458a499c9f6f38773ef446c1ca2ffae2bbb351aa42e166e63c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18bd5c79c67b32cb1da895900ccdfa5db5a3f45a1faa0dded86079a6637e1892"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1e1374dc01dec922cd846a77c3b031e85b9396349ffd2b643e3091b221d7de3"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b504f0273dfeec69afa28805ce213bc6151c4125b6a7e6ab20fd766fa8a9b41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3adf141358d2b10e00d42dc6de06275eaa6798baadaba2707661bde5aad015c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ee6cdcfca47a075ab9d532fe163857e0da3e75df7c80138576dff0a82115e1c"
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
