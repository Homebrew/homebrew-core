class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.13.1.tar.gz"
  sha256 "95b4b01c43f23b8d4f06030b57c9b2e47a4fbbc4f6099acaf6e42d1f1697385e"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d0e3d3ca1b9e4fde822fdf889a3cb3e2d0951aef828318de299ac24dcd594ac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5387ee7dcc33a8450b38e9918408e0ceaa5fa3267c0fe0945502e73805a9eefd"
    sha256 cellar: :any_skip_relocation, monterey:       "82b67714049d9ad391159ffbd56bcedf75334a88827975f5554a3598d966364f"
    sha256 cellar: :any_skip_relocation, big_sur:        "97adb337df046e2a97795d1397aaafd75ef210a0123d11c1cf26b7ad48eba4b4"
    sha256 cellar: :any_skip_relocation, catalina:       "d0372781cb78929c1643218af844febbb26bc18aa302cc09a283319e1156d4be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e7f2e01195d9d1b82d33f762d2205da56a076b066258b1f46d8106d7b5f4588"
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
    PTY.spawn(bin/"broot", "--cmd", ":pt", "--color", "no", "--out", testpath/"output.txt", err: :out) do |r, w, pid|
      r.winsize = [20, 80] # broot dependency termimad requires width > 2
      w.write "n\r"
      assert_match "New Configuration file written in", r.read
      Process.wait(pid)
    end
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
