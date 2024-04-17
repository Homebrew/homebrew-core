class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2024.4.5.tar.gz"
  sha256 "b278bf2817976cc5ad172870d69eeb280a21c9bf787fd380e6f879531b9f9cea"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4695324089c39c6e9d9b92a34908b9fac081b60ffaaff41221a65a2f6f9046c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89d303b98060567326da58c3818694e824d768678f20df08fa9bc7260fa9c786"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3279b6641ace6bcf19a0043901eaa154c2f192f57df2e0493268a5f5b2deffa"
    sha256 cellar: :any_skip_relocation, sonoma:         "b48283de9898f49eaefc97e3c367d26a129f9ecd5a0a40e3831d848a83902806"
    sha256 cellar: :any_skip_relocation, ventura:        "8f614800821567a04012aef0074125d644718f2b2c18ee34c949e3c6fed4826c"
    sha256 cellar: :any_skip_relocation, monterey:       "83bbe9a19439f513c726d1d93ec999cccceaa5fff3ca07351185c78ce8139bf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e6afc87afae21e17167168fd081c532f8183b48d468953c8c7a9f1ba52dbd4c"
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
