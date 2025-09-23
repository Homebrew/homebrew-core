class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2025.9.16.tar.gz"
  sha256 "252f669ed2b2272984ac64761b01df78a4c69eab0b108b33254104012d6c776a"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "58307948e807357746898ed74eebbbe4ce975b2dd6fbd209e4f88196c8756761"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c1be6568f96fc53afced4b9dcd89e58d691a5eb421489fac8b10544a2b9da7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db4ab452e6916ecb8fe26a2de0399d65921164837dee44ec642e3c8fc32d6764"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ae5df4a811c50e27624a26d0bd324ebbfb90a16b054cf7374c3ef74aba84da8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a28786b730cbc49616155dd880039e91de712167f105f21899f47a7f43eb3de7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "add1a2200987a6270b1b15f04b4ac423dc84da7cde9b756e87c987758a08b183"
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
