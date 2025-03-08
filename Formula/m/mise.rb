class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2025.3.2.tar.gz"
  sha256 "baf39e90d7990843f27850b39ac54e65be0c18444927ec802563be8af3a7274e"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4488bf2251a82cd06efd058337ef4cd25bcde737020ced662ee9f05a0c947238"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c9fea33d1fa8a72297ce19d4bfeae871e2949346dab0d9ae2314c2a89466c67"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a21d0ab2778527dca7d5a6634058625b270f7a262db216d2cde830b5cd70921d"
    sha256 cellar: :any_skip_relocation, sonoma:        "0fea90eea6fe63a9b3d47619aa03c043b1d2457149e23bc5306bfaedbad4a6e9"
    sha256 cellar: :any_skip_relocation, ventura:       "c4023d6600e3206b18e58ce84b6da5406e95943c5ff9bbd0b11d96c197a21e93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "523a8746eb98ab1445b920b4acc4f1a69467669065b5b797d09065d247d1fb0a"
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
