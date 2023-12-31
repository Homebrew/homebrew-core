class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/refs/tags/v1.31.0.tar.gz"
  sha256 "8aee20cc8c339262dbfd1b064c261cf9628ec671124f94412c23343bbdcb691b"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c8b696a3fa34395351498d5b50f621adae77de6150f15f618ee554487702e5de"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5b746bf903cdf2c995d4dbf57f85c242a50c1f1dc1c9a0217b8d886292aa736e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8fc7b0863690521bc50f93843552d1746faabd7206fd064ae675d3ae2a21537"
    sha256 cellar: :any_skip_relocation, sonoma:         "33be1cf25843a063a458d23492b7724b926389008073d885a0f0d685a4f37e7f"
    sha256 cellar: :any_skip_relocation, ventura:        "8af474220ae51e2a1321d8038ff6c84d732be18df6d7ab5beeea7b42c77ad5b0"
    sha256 cellar: :any_skip_relocation, monterey:       "f8931732b9fb3e64ded3204ad78ae49f1e19972bb3a20ba65065f8ef986fdc65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23433022a31fffa2d76bb2425de1b3ded5140bb0d43597e84cde3deb60bde464"
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
