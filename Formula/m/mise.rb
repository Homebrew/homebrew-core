class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2025.4.5.tar.gz"
  sha256 "83a355d3d86382308b7bf1b911f7513804eaaeac52ba69a73e371aaaef6952cf"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88feb51aa25097d1e0f0bc76dfad2702378c8874d4bf2f3f72c3c256b33f0393"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74c6e9073ef7e102500b1310b6e5cd2775dc959f8abc2be07f5d1777228cd395"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b3758f009a46055e91ca71846ffac1670ecf9a1f0e09064bc6364a432ad36dc9"
    sha256 cellar: :any_skip_relocation, sonoma:        "e152ba78199809546865a19c2f40f452b8aa255ee9e4c200c90278df7dc6d320"
    sha256 cellar: :any_skip_relocation, ventura:       "0f5c987796f442205b3fdb429ee549d6fd3ff2c0745b6d097de411aca2bb6786"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f707bec21609014360379af1c8e87839ebcbfc4d617281d55bba9ed1ec909d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89593eb65edb458d7a7e948e4320f28a7fd8a9e38099581bf0422d2d04462372"
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
