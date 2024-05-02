class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2024.5.2.tar.gz"
  sha256 "486c2ef8dcb049b2a8ef6514746036b32b08fbf8fa520892c139f1f7b09ddd7f"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ba2bcf0196fe7a18df71b23ee8c05a817f580ccdc0611c4f43796f23dc67c2d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4efdbc3070d4d1a3c98260c01a116f4bdd7ca9d15d98e4a6e888d8ae8dba8080"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1bdbf888d45f5b8ac1387668f0f346e7aea76b9fdda90d3e7851f95849684ca"
    sha256 cellar: :any_skip_relocation, sonoma:         "977fb9a4eae0e6a18acede78b110505e7f70dad9f556fe52b8a690d9e7e804d8"
    sha256 cellar: :any_skip_relocation, ventura:        "b50a058fdbbd5bb60c54574a9eeb40e5e263e6ef7207de28ce6877c68e553daa"
    sha256 cellar: :any_skip_relocation, monterey:       "91fa6288ea4cbd2c1a379ae505cff3bdd553751d4e02e62527cf57ef0dad591f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b13ac10c750cadf161c1b22567f1570063e662afd3ada2ac07604ebfa4880b8e"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "man/man1/mise.1"
    generate_completions_from_executable(bin/"mise", "completion")
    lib.mkpath
    touch lib/".disable-self-update"
    (share/"fish"/"vendor_conf.d"/"mise-activate.fish").write <<~EOS
      if [ "$MISE_FISH_AUTO_ACTIVATE" != "0" ]
        #{opt_bin}/mise activate fish | source
      end
    EOS
  end

  def caveats
    <<~EOS
      If you are using fish shell, mise will be activated for you automatically.
    EOS
  end

  test do
    system "#{bin}/mise", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/mise exec nodejs@18.13.0 -- node -v")
  end
end
