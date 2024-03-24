class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2024.3.9.tar.gz"
  sha256 "113f083934b8f9096326c982c1bfaae7cd8596c9727c670a5210e6b3e452f809"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6738be12357aeaeaf0c42719f850e5208b2f5793b03728718069e9e93bb41dfb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2df968638ac65bb12fdddfdedc263641f952a0285eccfd57706f86c3f318bdf7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "768a4d871c9d5599bc6e1b4c6dda34afcc2fd97d0f1c921ab132697cf0990f39"
    sha256 cellar: :any_skip_relocation, sonoma:         "5cf33c75c311c884923b21018cca27a66bd9a3c8860a5ae0a278fa3c7ce4b895"
    sha256 cellar: :any_skip_relocation, ventura:        "6bbc073429d4ca2dbb554be217f022b482eabca2a9afdfd0db1d2408ee3a5227"
    sha256 cellar: :any_skip_relocation, monterey:       "c509ff0bc93f7d58600389aeb554753d451dd2f4b984ef29b75b70726b445026"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb06d5ca76de550a134096a4b4566a847a825a0056b22b8910b2ddac51ed81f9"
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
