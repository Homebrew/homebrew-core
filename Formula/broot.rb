class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.7.5.tar.gz"
  sha256 "d5a9829a203dd4db0cd8a35eb0dc4e84466c88aadb11c0a757cbcc1a5b5ef7c1"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "dff7e2c9690d686ab82b30b3dc5a89b4d9ef58c69ff43e680e93d5f078a8a29e"
    sha256 cellar: :any,                 arm64_big_sur:  "bd89b75e391c9da12c1cdaa91467577eeb167adfc343d7a782593ff6c4e6b5a0"
    sha256 cellar: :any,                 monterey:       "232efe908d9024749cea3f489d43b2bcaec4ee094e528d64e7c9b338d6011032"
    sha256 cellar: :any,                 big_sur:        "364042776eb5b2630a56e7e5c4f645c149050f91dd95e943adf4d72b66dacf36"
    sha256 cellar: :any,                 catalina:       "8b41711fc6ad9cd63343723ab05b1a1d7eb41612fa8177b1642ad337e3432aea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "994ba9a017638692f10bfd19aa77ae3ee53b6e103a58d80f136314459f749753"
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
