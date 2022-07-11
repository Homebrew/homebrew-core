class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.14.2.tar.gz"
  sha256 "992e3b5c2b73a25366bf67ccc8d99a51be9c07c75ec6ea413883dd8a8857c2e4"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c922fb09e306448385fb9d9e33f092d0be01f44733509587588ff8b70db898a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "92e674de450c5fde4337f53071f66bb1818401fb6522c01aebabf520fddc7ff9"
    sha256 cellar: :any_skip_relocation, monterey:       "be840bed51bd98cc7582d741377f15821146bf0f31908cf14c4675cef129d962"
    sha256 cellar: :any_skip_relocation, big_sur:        "54196827f9c3960f8da6d18ae6c98b1a83650c11e71b7b7b900f55b2c7af3cf4"
    sha256 cellar: :any_skip_relocation, catalina:       "d878e21afa21c59a5e2ab7a611d051c6fa40ec87c7ff3bd90726f92d3f6f456c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "981b932867e7ad406a854af34f0b6d3f56ddb64b0abe775eec938db12c2901c6"
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
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match "A tree explorer and a customizable launcher", shell_output("#{bin}/broot --help 2>&1")

    require "pty"
    require "io/console"
    PTY.spawn(bin/"broot", "-c", ":print_tree", "--color", "no", "--outcmd", testpath/"output.txt",
                err: :out) do |r, w, pid|
      r.winsize = [20, 80] # broot dependency terminal requires width > 2
      w.write "n\r"
      assert_match "New Configuration files written in", r.read
      Process.wait(pid)
    end
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
