class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.9.1.tar.gz"
  sha256 "5afb828b9d15f0ea2e06636f1a951ee51ca06826e96a892813daebdc7bb90a59"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "273e3890e72b080f0f6239d3256fc9d03026cef67fa357438906543bc073e381"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "51d41a355994c5e003f2d417d7d82860a3bd0d2cdd8f21db8bc4798c8edbad07"
    sha256 cellar: :any_skip_relocation, monterey:       "80c991da60efa07afb4f47cbb6462871677129c039f0399af47af905754aa31b"
    sha256 cellar: :any_skip_relocation, big_sur:        "574301344c56545db948fb1fd3a6259409d83207533683aa57ef7987f4661222"
    sha256 cellar: :any_skip_relocation, catalina:       "9074ef4dc95b6d4c8e4394c4686ca28fa861da93f4bb7621c7df9569be30ccaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad82c3208f894e6d280c6498870f5c0007ef207d287988bc384e06a8f932805a"
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
