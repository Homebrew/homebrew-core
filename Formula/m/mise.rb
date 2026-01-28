class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2026.1.9.tar.gz"
  sha256 "2900923eaffd95e9a20fac03001ee1990760923d177ff8db0a04bc6113c46e81"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e4ef9d9e7cd10413fee4d8b027212b01ce6b2ea753600bef2db935514bf31b20"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e517a6da31896766682b8944ee94708d34931fc9c729ad19d6de5c7ee0c8160"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6aaccc8ee2c2ebd39ed909cef78602a189657c8bb53aef144520d59b50f075e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c498cbab0d6993dde4c42f88f78f1ea2be0a0bf7240a42a9e86470b71fe9494"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "257b6aa22151a7dccb2e8927f7a2d71eb57480eba004bae07f356b40b59f9e0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "164e9dab8b563962221dfde53dc239221e9f0b82dced2756f62e823a6d372760"
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
