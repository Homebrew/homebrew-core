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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "123d4bd7492b348ac8085d28d945fad7c99de20ba97013f22bd479133e95474f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0db2388f20c62c83222a86573765874cfdf7886952670f25dc58d969db441b14"
    sha256 cellar: :any_skip_relocation, monterey:       "f7f118824a68f084bff602bfae694c952b7714e70c2ea7cf59aa61df678f3cd9"
    sha256 cellar: :any_skip_relocation, big_sur:        "da6919e878953362cf0070f9bd4fcd8d5eb59c2a694899dedef59ee919cea029"
    sha256 cellar: :any_skip_relocation, catalina:       "5bfe28f0fd7e67574277e6b0edbef6c427da9b7d2248ab522675a888df21c6b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba4650a96bbbcd7f5e071f88522073271d6d3d2800ed793d3eefb01a8d29343b"
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
