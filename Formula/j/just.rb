class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/refs/tags/1.25.2.tar.gz"
  sha256 "5a005a4de9f99b297ba7b5dc02c3365c689e579148790660384afee0810a2342"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1b2b02df80421d22beaf2e0ece653ca19f627627ffbc48df9cde29e28976ab7d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5858b6e59b86bcd3afcac7184faf77a2c031f24da04d53c4071c69bd6a5a17ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27098ac6aedc9f48f08385032100598bee1781ce0e8651d83223ec62195c3c08"
    sha256 cellar: :any_skip_relocation, sonoma:         "674b408fcc6164b698c8f808a4d99c58ca683dec5cdff24993a00de78381f9c0"
    sha256 cellar: :any_skip_relocation, ventura:        "c6b80bf689ee7f84b0e97c8032b8b34556c56e80d45dcdd75bcd3f6e91004a77"
    sha256 cellar: :any_skip_relocation, monterey:       "8e15d2ceea4f1f3972d73910d2244f6c099df1886caac6bc3b1f6250f7a8c5e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1d1c30ef56429b4dcb09cea910f75d3b04b080d672b19e6d0642b3c53b2d5fc"
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
