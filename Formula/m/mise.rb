class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2025.9.24.tar.gz"
  sha256 "0e94caa67f3c3de750a6f7c02bd1b40c28c978d26ac9bc2aa93bb4f4daeb1d33"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c155003f7e0e2f89218d4642a90bb0dfbd3e1f00a733c0cb17ff0fbb89bf168b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd3222e272329e73d8478dda5f571dfcc86096a232e5b03d6dfb45598a36164f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ea90f55cf911480de1f462624361a9dcde6364a39183a23381fa517a4ed8fc5"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b2e2a94e392e2328b3a1a065d40d506b5ebad82c184bded095274b6842b1458"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "abe103ec45d78547083d9d30423a3e8621dd02cc373b44258e9721ed1cd46d43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73973b738d21afec70f281068f9166ab9f9899e4ea9421a5501c98a2ed711732"
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
