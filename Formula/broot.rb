class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.7.4.tar.gz"
  sha256 "b9c435b5cf0b05c0eb17b3934df961f3c73461153fa7fc3d50517735b048d49f"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c3cb554a8f7c8504d1922d43b5876832b196497e684f993d5f6cd1667b5bf93f"
    sha256 cellar: :any,                 arm64_big_sur:  "26a99838e747de7c9a9306891480059309991c94acdae068947f0ebf7e25cc20"
    sha256 cellar: :any,                 monterey:       "085d5360b9f9579d5bfcd347f6c224706cf04f9e25e9ac15942aba87a43f946f"
    sha256 cellar: :any,                 big_sur:        "949fcdd47a8704503611710db0c8dae190d9d0a7f2344eca5e8d070b4fe04882"
    sha256 cellar: :any,                 catalina:       "9166ac9dc5000d189c2d26e2a563d4a984d774957fd6d2c6d77edc6f14159389"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f797139f82effed5188c1f103fbdb8ad33ac2470a5aff59d5e6d872555572154"
  end

  depends_on "rust" => :build
  depends_on "libxcb"

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
