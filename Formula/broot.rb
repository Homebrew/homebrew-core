class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.2.7.tar.gz"
  sha256 "7e592f79e5fd6766bcaa67e6635f2fc2f7ad08dfa9410c6713f7e06609856812"
  license "MIT"
  revision 1
  head "https://github.com/Canop/broot.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "eca86be9cab271b8460deeab74a1f31edce844c7cecc15e029ef539a3e238899"
    sha256 cellar: :any_skip_relocation, big_sur:       "e04da40ae606779a659ef31fd13c193ec623c9c252d62cc9f928fe94f14adc79"
    sha256 cellar: :any_skip_relocation, catalina:      "5be93a088ac57dfab3d3765c35025a43938a292f2c353510030568ea8221e6a5"
    sha256 cellar: :any_skip_relocation, mojave:        "71b8b1391b86e3c2829ff245e1799a8b7964db71377bf53a24e1f39c3a407509"
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
