class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/0.10.6.tar.gz"
  sha256 "9ce39bb5230471ced8bb58d7e7cb4a3fc3cfd1d7ae54cb38a24dd24b0cff14e1"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a18f7824881ce4209d329044c7975140188eed2c6f920095b1061e38ec6fdb5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee05b371700181aefdfced2b5110fbf1cb84e127e601236b00dfe80b3e91fc50"
    sha256 cellar: :any_skip_relocation, monterey:       "78bb321f7549c17bebbf959d5fb37a9568568d568ddfcfaf6a6cd6e9f623c215"
    sha256 cellar: :any_skip_relocation, big_sur:        "5ff4d51a52443be3695b9d012d1b6b370b3210a78394a55feb871624c8b94554"
    sha256 cellar: :any_skip_relocation, catalina:       "91324d6ac6ec734f6ed830e6d2b2948c18080714939bd24b96ba49ed4edc27c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9a1d9282873d60b07244fc64ea33cf003dd4982e02affff2afd09b43fcd6375"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    man1.install "man/just.1"
    bash_completion.install "completions/just.bash" => "just"
    fish_completion.install "completions/just.fish"
    zsh_completion.install "completions/just.zsh" => "_just"
  end

  test do
    (testpath/"justfile").write <<~EOS
      default:
        touch it-worked
    EOS
    system bin/"just"
    assert_predicate testpath/"it-worked", :exist?
  end
end
