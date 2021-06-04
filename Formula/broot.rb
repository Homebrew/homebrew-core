class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.5.1.tar.gz"
  sha256 "af7467aa4331dab9a556ff1b6c265eaa6b526a85ebc1f499d091cb719e1db364"
  license "MIT"
  head "https://github.com/Canop/broot.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e90fb2484ba9bc08c8b498174d1c45f0a06b055529ba02bdf887ce5a3881e94b"
    sha256 cellar: :any_skip_relocation, big_sur:       "99611d7a69c70303626e745d02b2ddc83580393db3f8eb318656108a1868df89"
    sha256 cellar: :any_skip_relocation, catalina:      "bb0b419627ff9d746fad37e98f1ad4b25d3da7d68009d9d985e6b6188d5e2e7d"
    sha256 cellar: :any_skip_relocation, mojave:        "7da96ac53fa9c2ae7fa92a57e70f22f552759d469785b836cf8025c22c1229f7"
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
    on_linux do
      return if ENV["HOMEBREW_GITHUB_ACTIONS"]
    end

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
