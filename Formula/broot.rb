class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.23.0.tar.gz"
  sha256 "4dc855cb67eecb203759b88fb819fe4e725ea646dfdfb7af548805d2f98162b5"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b5770e4e37c3f5a0134e28d3d4888437abcafb8b30b7072cd371bf1a6768876a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "395286f5d3e74d1491cf7e5a448231135c3fc803284ac702d3906c33b5afbf4c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e4f99f6dd5cbaf6708ffce0258c6f995988c2170b57e7bb5fdf256e88769e172"
    sha256 cellar: :any_skip_relocation, ventura:        "aafb1efb621c672d3073d9a86eb81648c4c5038156bfb77495f2f536bb934a43"
    sha256 cellar: :any_skip_relocation, monterey:       "c778e4e413d6a752e9944508aeb569da923d9c646554e6b731353aaf519d9756"
    sha256 cellar: :any_skip_relocation, big_sur:        "3dd86c6d8eb82f4d98388e8372039cc404ceee60f147448e10d4291031d93b45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c01358e26ea94f7a4e68046f3905206eab7102bc5825c62320f4d47a7d36115c"
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
