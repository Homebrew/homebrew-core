class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2024.2.18.tar.gz"
  sha256 "5c5d71b8e0f319f0b330e9e6a7ffcd80004f5a521a0599a24aeb5d07d3551c1e"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "30a889a8d27d1723a5d0e221e5f99ad661fcd46f4d30a03a1252f6d3587b2092"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2454a8d0efdf017c41a7fb0d9b4bc62f20a6c01c63f9106531b5bdf9561f01d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03a5b9958b041235d0febfeec8f1bb42a4107a40bfff7ac1dcf59753139c5a3a"
    sha256 cellar: :any_skip_relocation, sonoma:         "42d134f5e39ab65d6b04bfff250bd22ebb49e6c27fdf1a506ad1f1d4a295b3c9"
    sha256 cellar: :any_skip_relocation, ventura:        "dd5a5ab1ad2d9a4888191d53448101b7f5064bf4a245801c07a310b85f3f17ff"
    sha256 cellar: :any_skip_relocation, monterey:       "b8de306aacccbf6e8e5d7c769153c6a6b679452b5f4f99c01e3e186c1e703cd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a196d74dcce207bc7ad4f8551d91a5269323e92dff8d1a5a631029be12c1aff"
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
