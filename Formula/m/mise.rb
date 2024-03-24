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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f2816ecbd925dc70b0043d7ebe989a322c6446fa71aca7ce28789d02571c1750"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "46467f2f56a9a15eb5ee38fd8c3c9e76a5746d4ce0121ecce867ed72ecac5587"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b184cdcdbe4cd40b19f28c6deec4a8e2c20d40a1cbd8616434ac61bcf4595f6"
    sha256 cellar: :any_skip_relocation, sonoma:         "27c14a4e257da51b340d38d60695b96eade19854030e05e4f8996a94f132d5db"
    sha256 cellar: :any_skip_relocation, ventura:        "65301d6281483009ee48ffeadd557ec5241a2fe239ee3938963bede295118b61"
    sha256 cellar: :any_skip_relocation, monterey:       "d9ec55f600b13a21cebc471da66641445b54b7af38306fd33106ea80ced703ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "537d7f47f524b09f1a548e9b9b5be021fa766a23d72324424dded37d80ac24bd"
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
