class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2026.4.7.tar.gz"
  sha256 "8bf8a22520c50543a5642bb0151de1a31ca7b12b2e0f3ff6dbd2e803cbfb3b84"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "17c3343dc1ba31e49951b2624fd3713a37ebc7b09635e8c9efba3bbc9e31f32d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50255fce00b208b9d9b92b3914afd5bf1f94922514d86b450be581bc214a0c30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7d017592625b47da101e62f660876f08ca2fa44eacae6f0e0d12e118e158e6e"
    sha256 cellar: :any_skip_relocation, sonoma:        "246046598af6c22d2b183919cc53c283488c7e033a43ea9914371a17cf2849ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8022d3ab701b5a6978c8d03c232bb00c74b9b9f0e47fac74fc639a6c85b3e8e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2cfbbc7864105ba6382876f5f81eb208f3324a425b1ba99b0ea4dc4ad0919b8"
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
