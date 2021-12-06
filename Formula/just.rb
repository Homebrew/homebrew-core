class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/0.10.5.tar.gz"
  sha256 "02e452c0045879161ce820dc66e60d10b3e2cb9b8b152ff86cdd9221eb65d1b2"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bae9785bdc153e1d591ea8b02ac5c91a46ad88a63cd342322e21fd2f706e733a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "96890ef0a3dd0196021f90fe3f5ed59800c8a001c78bbd1afd00184b58f6d236"
    sha256 cellar: :any_skip_relocation, monterey:       "8aaf68098fc50c988c97c38ba68dbc548ee9852f973b18bb5e46dd1b14b245f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "6387ce3af5769bc5136c7176b7de5c027edee04abc411b16e53ad40fa50d562e"
    sha256 cellar: :any_skip_relocation, catalina:       "c29ee1411073506cec9d103b6e7a9b2fc7e48a76431bd99aacbd35fdd21d6a29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20b3f50da02c3270d2f10c2db22680a89fc432f7c5011f7a71bf4f66ba98443e"
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
