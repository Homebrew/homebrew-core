class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2026.9.12.tar.gz"
  sha256 "6d708b6c6f676a86c81f82506a4911517fe9574775cb734abd0c4c739efdca47"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "047d86c5f19824a91c65613a2eb7270b0bb4047c13671985e63b11eff593b069"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "51b423464b590b91a09bb78341b332368aa6e5b1dc9399bcf957210b331163a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4bcfeee920830e95506aabcbb88d7a2c49fe0c6f2feac19fcc8849c5a84bfc96"
    sha256 cellar: :any,                 arm64_linux:       "4cb3d189109b1243912e6bef73e2785ca0ac1be57fe182f4ab2bfe70ba21a1cc"
    sha256 cellar: :any,                 x86_64_linux:      "c661cde34c85681a2e643b36184a6451e3eba81b391f1182e101e63e85cd1855"
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
