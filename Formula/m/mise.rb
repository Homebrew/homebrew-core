class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2026.11.14.tar.gz"
  sha256 "02de295b741c6869f9e1e23c3cd58756706070a4f549467c8a83d5e16cf9d28e"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "8f29c58f13ae458a475e30d1fcc18e012c6eab94c4d142be7df91d1dcd969672"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e30e34dd7ebe8b9116e1d410906a38a5c1273ec5b527f3116eb7136bae2296d2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6768fe83fa6fca865a101c63b673a8f06fa33d17ad58103efafd3bc72c1116cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "feecb9304398afff8b1706266b9437f8631fcb82279b38192008b5eb48836c41"
    sha256 cellar: :any,                 arm64_linux:       "5b70e64ff2ca6f19a6333b93bc383c1e8590a33a7dd1159e0fe7c5ef3c4938e8"
    sha256 cellar: :any,                 x86_64_linux:      "e4ab4a75cb8f11ae8307e51ee1c9f3e3fe0ba13ba098e40b5c7ca1d2084d764c"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@4"
  end

  # downloads crates during install and binaries in the test
  deny_network_access! :postinstall

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = dep("openssl").opt_prefix if OS.linux?

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
