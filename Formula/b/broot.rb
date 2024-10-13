class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/refs/tags/v1.44.0.tar.gz"
  sha256 "a235f9e326d39416b484ea5e677642194f726b7683bd2d5dcd1520ba37afb34d"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "28b4df80cc3bbc17bcc37209a8a6244bb262c8a6684245b919e4ae160262ac97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bfd9e8ce40bba6628a8e927a0fa5f15c94caf8bf5301fbfc3363a9dea7e16c2c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6828c9677283a9b9e261d6cfed4136e58333152274180fa54efd2acc0fa0ab2d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78f64820619d6260b07ac016aae26766f21059048224033cf435bdd7ea75dd6d"
    sha256 cellar: :any_skip_relocation, sonoma:         "22e422df1ed9511c8bdcb7ce79851ef1ee19e2867767f9cb2474fa9244a7bccd"
    sha256 cellar: :any_skip_relocation, ventura:        "91c748c42eab51ff77bbb45e8cd624606e91fb5b3fe4be3d79ac8fe33e4832fd"
    sha256 cellar: :any_skip_relocation, monterey:       "bcb1ba8dc609296d60b3813377f552dc92146b8e71bcd6e1e1e4d0d62c2a50d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7790acbdade308c9bb60619749b8c84b594b6a7b1ef39244073af1345ff7e974"
  end

  depends_on "rust" => :build
  depends_on "libxcb"

  uses_from_macos "curl" => :build
  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    # Replace man page "#version" and "#date" based on logic in release.sh
    inreplace "man/page" do |s|
      s.gsub! "#version", version.to_s
      s.gsub! "#date", time.strftime("%Y/%m/%d")
    end
    man1.install "man/page" => "broot.1"

    # Completion scripts are generated in the crate's build directory,
    # which includes a fingerprint hash. Try to locate it first
    out_dir = Dir["target/release/build/broot-*/out"].first
    fish_completion.install "#{out_dir}/broot.fish"
    fish_completion.install "#{out_dir}/br.fish"
    zsh_completion.install "#{out_dir}/_broot"
    zsh_completion.install "#{out_dir}/_br"
    # Bash completions are not compatible with Bash 3 so don't use v1 directory.
    # bash: complete: nosort: invalid option name
    # Issue ref: https://github.com/clap-rs/clap/issues/5190
    (share/"bash-completion/completions").install "#{out_dir}/broot.bash" => "broot"
    (share/"bash-completion/completions").install "#{out_dir}/br.bash" => "br"
  end

  test do
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    output = shell_output("#{bin}/broot --help")
    assert_match "lets you explore file hierarchies with a tree-like view", output

    assert_match version.to_s, shell_output("#{bin}/broot --version")

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
