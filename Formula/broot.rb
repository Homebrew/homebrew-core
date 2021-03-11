class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.2.8.tar.gz"
  sha256 "2951e0970fdae20dbbedaa9fdf666dd73bd64c0060a40884a21d7e1ecfb95f80"
  license "MIT"
  head "https://github.com/Canop/broot.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "441ef23c9545037fb7c4772fa26e8eef6e4bb20c2cf6fee2168d28296e24ce28"
    sha256 cellar: :any_skip_relocation, big_sur:       "a5c05d6f27f504b57158b977d9a5ef183c4b394304ef92b2aef27f3647907773"
    sha256 cellar: :any_skip_relocation, catalina:      "a95addf7cf8218416637bad98e520d5cdcd984fba34ab379e4fc2bf9c74e2d62"
    sha256 cellar: :any_skip_relocation, mojave:        "760fc93d0b10995e601ab52312e6ed7e82e73008b286668cc73b5b9aa0d76daf"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    # Replace man page "#version" and "#date" based on logic in release.sh
    inreplace "man/page" do |s|
      s.gsub! "#version", version
      s.gsub! "#date", Time.now.utc.strftime("%Y/%m/%d")
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
    assert_match "A tree explorer and a customizable launcher", shell_output("#{bin}/broot --help 2>&1")

    require "pty"
    require "io/console"
    PTY.spawn(bin/"broot", "--cmd", ":pt", "--no-style", "--out", testpath/"output.txt", err: :out) do |r, w, pid|
      r.winsize = [20, 80] # broot dependency termimad requires width > 2
      w.write "n\r"
      assert_match "New Configuration file written in", r.read
      Process.wait(pid)
    end
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
