class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2026.10.25.tar.gz"
  sha256 "3ac9d7138fe993e17ca79d8efa76ce3a8d554b626c0bfafeb94639b5dc6ab879"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "76274c6581eeaf7e467956d9be83107c534a8b761c0bfc8f93879b8118f911c4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fadc8a02d4e8b3428e59dad08d67e3acbb3534b164331e0be2724fa944436915"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4ad1b7d4204b9c1de3279be99e0a81c6e0f60649d79f715a4dfe0090143662e7"
    sha256 cellar: :any,                 arm64_linux:       "10911dad5bdd26aa0b605d2b32035bdf92e5252d9737abe7aa2c00531062c2da"
    sha256 cellar: :any,                 x86_64_linux:      "1edc13db5e56373cd4029b28358582ff12453664af2c7cccd30968de1a0eec66"
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
