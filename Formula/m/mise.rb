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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "25d5558716f624f25d2a71c8cca3f119ff85f54a97ac773c08f96c2aa45c28e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68455561562d73acc9a12f1df6d16724e8f7068130043cab62185022ca521884"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e616423e0f706a1d7b47f34bc14028fc077192e4ba534531e06c16336d080df"
    sha256 cellar: :any_skip_relocation, sonoma:         "762db99a3c35a1b1bd64c32f40c83e94a340f1d9c2ab874e71317733be014a2c"
    sha256 cellar: :any_skip_relocation, ventura:        "6ea841e41bfcdd231a33bf7ad97247209989012161b5e284e45cc1fd5465043c"
    sha256 cellar: :any_skip_relocation, monterey:       "323201695154ddce82d58f904b77616c88c4dc8b80404bdf105bcdd12177fcfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "020abfeb5c3e6a20797b48037495d94a6501cb292b11b1eaacfdcdbe68659de2"
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
