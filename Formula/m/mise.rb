class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2024.3.6.tar.gz"
  sha256 "5fe51ad21dbc24a2ebab9904b911c6eba9db4df3865153f100b26e4dae19c7a8"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c986e7d0a694f2678b4e20519cd2bf3df33fd781e204cc53caebb6cafd2bc074"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "54eca50757e5d7a148fae509f45374c6857e31aee3a8cca6f58a7bb815ba25f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "626c256b6f0c90ef169d01f32e68c68b3da88759bb29fd517969cac40f839ec0"
    sha256 cellar: :any_skip_relocation, sonoma:         "433389206382d5b69af66890bd6532b08798bba5b494cc99c58376198430d9ce"
    sha256 cellar: :any_skip_relocation, ventura:        "7ea63be9bfa98853e03d8eb4d50ff54a620633b12fc6a58f4784b708c587c42d"
    sha256 cellar: :any_skip_relocation, monterey:       "97d6b52b1b4f406e6d5f1ce8d598343ef473ba341ab0c64a98fd1bbfa9c814ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a00582999526eff8a943bad4526f4242ea9f59ecb2496183fa7ad46f858de173"
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
