class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/1.8.0.tar.gz"
  sha256 "5c78163d3ee45f838a2a69f0ac2866f901efe2a0d9e68875d1e12260951a60f4"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3bdf1e5736c6948550a3d85eec8cb21b26539b407ec31509a841255bc2b9a58c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "093d08040b48b27f002e6b009b6a2200da7968a8922b2914374204bdfbc8061a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d133d7c17744046327de79d037ddb41910708fc53d70817a8cb45f93a04d0d33"
    sha256 cellar: :any_skip_relocation, monterey:       "d891f4b3990733c36b10d55bafe3c58638222e5a6ec6c73fc318841f0387d9e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "c01df995929d6b6d8008e8802ade883274fc48baa048eaf7674d75dcddcb1011"
    sha256 cellar: :any_skip_relocation, catalina:       "c86ed45e142846bca381c0747d4ded584316d4135468bc039653445790400c7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d635707feec5a459ab667b98f918d92b0bab8e921422ead481a4f1d1d2a0c73"
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
