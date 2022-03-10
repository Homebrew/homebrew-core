class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/1.1.0.tar.gz"
  sha256 "b0eaf3c7da507be9ad8e0ce050a10459eeead72b94d50bc3261e3dcda516b03a"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07a3a99569e791a6b97a55ae439f98dd88869561afa39be27846a8e940afc061"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a9a94716835d5f4e6fb2539706748220a35fb1964d96004282ef546e5fd505cc"
    sha256 cellar: :any_skip_relocation, monterey:       "699ff6f87cb88d66cf7d5dbbd65a66481f2956031a72bd6d19932c928345b4b7"
    sha256 cellar: :any_skip_relocation, big_sur:        "4ec72c25c1557ebad83b00fc75416b9ba09d4a193dbba5f496c0f92aa52ddd20"
    sha256 cellar: :any_skip_relocation, catalina:       "351b631c58f6c0a04d933f11ed00c2a549c75dffe7da65e9118d53c732e67ecc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4401026512a46495bc70dd91e29d5ef0f77fe2e672b1aa1b5b091cf34352e827"
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
