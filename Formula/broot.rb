class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.16.0.tar.gz"
  sha256 "6d15efba6c790eb8c308acf5340917ff9eebce3afe4e6f5fbbef946a84773c80"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ca6db53d0438c43c33cb497d56ad48e8c830e4d7fa1c7a5ac91ea4b604e446f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cfd113df89cf3f07924ad5ebf7dbb9a862dcb5335fb274578d2120847273d09a"
    sha256 cellar: :any_skip_relocation, monterey:       "50c571556dd87a280a84564d7cbd471595124d40840fbb456a64b200b42d9af6"
    sha256 cellar: :any_skip_relocation, big_sur:        "c84a2b55c1d12136c56ce9f847d8f93cee3a03820cfdae466cfe4e62a0ee7a36"
    sha256 cellar: :any_skip_relocation, catalina:       "0a458f5cf1d9b145b74399b4a0e3d3601462c9d49f6eea62b548d8eb3da0599b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "183706e7170e7b5ea11eec2a85a002c67c754ae3607a2c696832bad898d0855f"
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
