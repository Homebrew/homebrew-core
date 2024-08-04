class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/refs/tags/v1.41.1.tar.gz"
  sha256 "a784f31833b4cd11386309c2816c8e2f48594cc7658feca63bc57886cd7a566c"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "47054f9f8f446214b9d14a8af84b96dfa847e7dd1b99a1a93976e7f032d57b91"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "181a6005437525521a69c1dce5d86a5427f258f4e6ab87afb60f11f852126e06"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "abd36ccd8ea8551fcf40e3c1ad2678bff10f51e1e1d50857dcbb4b3e64ce4e98"
    sha256 cellar: :any_skip_relocation, sonoma:         "689b5a39a61c242c269c55c59fd6f8e05b15a33055cae85a1fb753f812d3883a"
    sha256 cellar: :any_skip_relocation, ventura:        "695827b0159a7d2fb2f2bc1a0820a1301c6f8211dd445374c0164ca917b01e29"
    sha256 cellar: :any_skip_relocation, monterey:       "16b506b4f31e34e015ed8aa56ac68036f7017867508029efadd6d75d3ebd1722"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca00a9395f2ab322467fa487685e57e35d295339cc2415d5e708fa00db541c9c"
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
