class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2024.5.3.tar.gz"
  sha256 "0d81404d68d04cb6da6a5ddd3fd55cae24c2b6a2ad11f83600bfa33e1f590f98"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "59fac3fd2b2a87125df3072b6ef49b2e9af0cd8eaa99bb45feace820ef41aaa7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c945dae8231604e62bbc963a6eccee89308cdca496ec3691e007b5c92ba0afc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1117174e107fd0a73c5d27571a2d8447c9610ee9a7722f8960b6ec270c10ecd9"
    sha256 cellar: :any_skip_relocation, sonoma:         "3697e3ac88234ad6725bc97a3f4d68bbd9f73efc2d25668d02fa5db3ded44d99"
    sha256 cellar: :any_skip_relocation, ventura:        "f6138b386f14ca7c8ef36d87c81db70d3f57795521c700a2dc6a3ca67003b638"
    sha256 cellar: :any_skip_relocation, monterey:       "59e8a2822f35faaa1a9b22de6f72c9e164691205eddaffd0a2872794dc36fa2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9584af06b155c191bea9745862e90349f1847fa36ada6097e8d0613986c51189"
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
