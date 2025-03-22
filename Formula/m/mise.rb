class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2025.3.7.tar.gz"
  sha256 "44256cca94b72d6975ff4a72ed4558bea0485fc4a23007c88305404656d9d1bb"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08ba66bbae280af2eb8ce000f3d6e8952f50e3c0959afadd543e9d04bc0d0406"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5bc4129afbb94a3b610fda200f3f82f6b320032564ee4006326667d1ae52c48d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "38d8f0840eeeb47c05eab73cd85a80387cee5af89647e247897795a6b77b0fd4"
    sha256 cellar: :any_skip_relocation, sonoma:        "3249c38255a511cd918067b0d5f0ab738136558d0fc9cf4c42e25b30d567fd0e"
    sha256 cellar: :any_skip_relocation, ventura:       "47f4e8e146c4989f775464df120622eb57c5c58ca44debce3b633323d6c38b35"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18f2aa3a2cde72f04676bb7811c66d24a71e9f7cf561e86129fffe3cc69af3f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c0ee3a4ccb3465df381fb1d7dc05253445d34bcaa8699d008a5f54b8882ed19"
  end

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
    generate_completions_from_executable(bin/"mise", "completion")
    lib.mkpath
    touch lib/".disable-self-update"
    (share/"fish"/"vendor_conf.d"/"mise-activate.fish").write <<~FISH
      if [ "$MISE_FISH_AUTO_ACTIVATE" != "0" ]
        #{opt_bin}/mise activate fish | source
      end
    FISH
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
