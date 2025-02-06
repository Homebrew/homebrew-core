class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2025.2.1.tar.gz"
  sha256 "9fe245786b34eca166f2001358f8ddac9632c38739fdc559f378d2536fff559e"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16a41b80bb6cfc46e648e9cad7c53dce6b1425c6ec02ad776cf6261206f2bce0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b495122dede2f8b7055ade567c13c037ba78b7d8ecf8f1da288cae92e525e49e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "efbf57c7a97902f8d7000737e2eb062f3572356b982f483bdee2377ee1013e60"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4b5dd7b31acea58911cdd2fabe324665458359b0e89420140f4c794de811abb"
    sha256 cellar: :any_skip_relocation, ventura:       "1b2d77ce08fb045283d5c19c87f73d9ccb0d931784c06c0a91734a4e8ec509d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a177494ecc44b83803705f9af31f618be2345aec2d2e0482062782a177af89d2"
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
