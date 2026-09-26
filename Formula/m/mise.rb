class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2026.9.14.tar.gz"
  sha256 "c0cf95d16c47d772eff1e3972019d45966961c664237e366656dcfc978283090"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c1fc207c92b0eabf2f072243a175a8ba75053c520e7373b2e3b66eb3b114202d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b303cbf7f9873d7a08c4db72d6c6a98f3e65ddec4dd50f53233984a22c299032"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fdc9ced36dd793183c0a569ea78a04199310b36943d2dde6503308bd22ccc5f1"
    sha256 cellar: :any,                 arm64_linux:       "9f665e9423d2fb0eec268c4ff3077431efaa7f0ca1ba27b28fe6585a17e429ab"
    sha256 cellar: :any,                 x86_64_linux:      "fdc335e3ea10798600625387d44a744e2e1e5a4c1eda10d739ca923c2b675e17"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "lld" => :build
    depends_on "openssl@4"
  end

  # `test do` block downloads tool binaries
  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Work around SIGKILL on arm64 linux runner from full LTO
    github_arm64_linux = OS.linux? && Hardware::CPU.arm? &&
                         ENV["HOMEBREW_GITHUB_ACTIONS"].present? &&
                         ENV["GITHUB_ACTIONS_HOMEBREW_SELF_HOSTED"].blank?
    ENV["CARGO_PROFILE_RELEASE_LTO"] = "thin" if github_arm64_linux
    if OS.linux?
      ENV.append_to_rustflags "-C link-arg=-fuse-ld=lld"
      # Ensure that the `openssl` crate picks up the intended library.
      ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")
    end

    # mise currently requires the vendored version of Lua 5.1 to be built
    # https://github.com/jdx/mise/discussions/13290
    features = %w[native-tls vfox/vendored-lua]
    system "cargo", "install", "--profile=serious",
                               "--no-default-features",
                               *std_cargo_args(features:)
    man1.install "man/man1/mise.1"
    inreplace "share/fish/vendor_conf.d/mise-activate.fish", "mise", opt_bin/"mise"
    (share/"fish/vendor_conf.d").install "share/fish/vendor_conf.d/mise-activate.fish"

    # Untrusted config path problem, `generate_completions_from_executable` is not usable
    bash_completion.install "completions/mise.bash" => "mise"
    zsh_completion.install "completions/_mise"
    fish_completion.install "completions/mise.fish"
    pwsh_completion.install "completions/mise.ps1" => "_mise.ps1"
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
