class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.16.1.tar.gz"
  sha256 "1eb13f2ff6acb781886a742be43ed5e421fd36eed981806e136bbc8eb63fa63a"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4c37752cb808e460b7722fb428c8d80499f33b424f01176ce5093fec0851f71"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8d3c9effc88c46d3dc02419850fe814d32471826c6a9e5611597e6f39e308cdb"
    sha256 cellar: :any_skip_relocation, monterey:       "f6cce159bca38a384bd782213fc7f3f53383ff8cef867a389f62e007a1cc9b2d"
    sha256 cellar: :any_skip_relocation, big_sur:        "c75a5f5e9351ed5b7f59cb12cf36614fe31e59191f3686fe39216d6be146778e"
    sha256 cellar: :any_skip_relocation, catalina:       "dd6e84124a8a793f0265a8e741e5d4867ae6629674e1512d58180979cdaad6be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d162d65146c16cd636bbcfb7fb711e085e046a48fc41783c6af6997a1980887e"
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
