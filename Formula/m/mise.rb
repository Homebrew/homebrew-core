class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2025.4.10.tar.gz"
  sha256 "c02b295883dee034547248d92247f0d23ab40cf454d4b41bea33b721550b18d5"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25398a0d09f6c3f066ff64357f92aa7605f91dbdebf4164a29648cf145cece5a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72029c888175948b6724d83c07ad2799851140cb4a936f4352b4de58a77e9471"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "27f0fb2a14eedb426c92403d6ad496858ea70fe0ef4ca8bad3a4cfff7f7425fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "21c5a7e67cba59082b471646fd5985cea522c3df4c75a41ab59448ac878a3600"
    sha256 cellar: :any_skip_relocation, ventura:       "9244a81feca30f459d7018ccf12411127b33f28352515889871633cccbaaa2c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e2daf22f6a490a83d247e3e7bb46f3d4f63836726221212ecbfe019bbdc7682"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "323286fae63f338173504748f6af1fe9aae7f34b7b910e2f1b34a40e02bce622"
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
