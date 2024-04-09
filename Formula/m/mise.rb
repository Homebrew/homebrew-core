class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2024.4.2.tar.gz"
  sha256 "887f94be6dbf75c00dba1cb660e913e480ae37c894372b682b327937b802ce86"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5cf496347e05cb8a2e311aa599404e9207143b8b5f97843cf19b093b8f22a17b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "96b341f7e30242abb28c5de85e11b91bacf28b2d04c472c983da72150860c830"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10df7168a4e7bca8969fc62e024e773d3c7c3f0117af2d75c6e4ea36f153ba0a"
    sha256 cellar: :any_skip_relocation, sonoma:         "428250e2c2e6a524b71f36bea42f3d2e5cf77dfe67a522117a72822bd685970c"
    sha256 cellar: :any_skip_relocation, ventura:        "8485c4653e9b574da46a978cd26e1e4a840bb006b0960fe3ba52fada1046ab8f"
    sha256 cellar: :any_skip_relocation, monterey:       "6b1e540b78b35fd4d4acceefc74cc00a769167befb0cddf72d8778a4e1fc1073"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32cec83a320b2a6bf162f9adc516a2099460d08127b7b5b24a5985b1c6640c64"
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
