class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.6.6.tar.gz"
  sha256 "95927b3f2c55f69cd87bb80672e697c83ad63dd9237fe3ebdd970b655d53a725"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4b2d6e32ef0b25158f02d37e13e2256780cac049e5b3cb02f930e73ea30509b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e131378e8c88e1401108675a82cf04baeeedd2c4bea9d5d10fd876064d8756fa"
    sha256 cellar: :any_skip_relocation, monterey:       "cb022d6612b55839918433355164b992438f14f7c4d568a49e1437f55783c550"
    sha256 cellar: :any_skip_relocation, big_sur:        "3389152727e5ae6b70eed971859c31950f13b52b923a87f7b15617645992d8e3"
    sha256 cellar: :any_skip_relocation, catalina:       "8970f833a720ab59aced6f44a2adec0bef98aaeacdbf0e37752447d333af08e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2df48d71e4bf9efcc8a06e11f46f612ea6010924fe5d8e4ebe6c8b7a8dd0eb8f"
  end

  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    # Replace man page "#version" and "#date" based on logic in release.sh
    inreplace "man/page" do |s|
      s.gsub! "#version", version
      s.gsub! "#date", time.strftime("%Y/%m/%d")
    end
    man1.install "man/page" => "broot.1"

    # Completion scripts are generated in the crate's build directory,
    # which includes a fingerprint hash. Try to locate it first
    out_dir = Dir["target/release/build/broot-*/out"].first
    bash_completion.install "#{out_dir}/broot.bash"
    bash_completion.install "#{out_dir}/br.bash"
    fish_completion.install "#{out_dir}/broot.fish"
    fish_completion.install "#{out_dir}/br.fish"
    zsh_completion.install "#{out_dir}/_broot"
    zsh_completion.install "#{out_dir}/_br"
  end

  test do
    on_linux do
      return if ENV["HOMEBREW_GITHUB_ACTIONS"]
    end

    assert_match "A tree explorer and a customizable launcher", shell_output("#{bin}/broot --help 2>&1")

    require "pty"
    require "io/console"
    PTY.spawn(bin/"broot", "--cmd", ":pt", "--color", "no", "--out", testpath/"output.txt", err: :out) do |r, w, pid|
      r.winsize = [20, 80] # broot dependency termimad requires width > 2
      w.write "n\r"
      assert_match "New Configuration file written in", r.read
      Process.wait(pid)
    end
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
