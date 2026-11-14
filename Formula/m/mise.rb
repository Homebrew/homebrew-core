class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2026.11.8.tar.gz"
  sha256 "3192f568f3897dbd0dde4e47d1b8ac8f858459bc7d8ae1b061d5c12f2a8841ba"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "99f4e2e203726d740038e97c9479362b2305d9ea7c145f70962f1554c75c4f56"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7231221fe20d78b276f04ee57e8b475168a9a3b7276eebe944a1cf26041bf411"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b9d970450c40a0a4aad9fa0970b3d2dc563c307e3c58fec706b6d2eb0e18cea7"
    sha256 cellar: :any,                 arm64_linux:       "842320321f1b6f74f46403690a4f8deb30def8d9b5e96f99520b968bda20eded"
    sha256 cellar: :any,                 x86_64_linux:      "29c505b4ee4d38703f684f00663828a49de27c0054a2704f1f5dbe3bf441f2a3"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@4"

    on_arm do
      depends_on "lld" => :build
    end
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
    if github_arm64_linux
      ENV.deparallelize
      ENV.append_to_rustflags "-C link-arg=-fuse-ld=lld"
      ENV["CARGO_PROFILE_RELEASE_LTO"] = "thin"
    end
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4") if OS.linux?

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
