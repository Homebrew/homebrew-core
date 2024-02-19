class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/refs/tags/v1.33.1.tar.gz"
  sha256 "d54f6f29caa12d1cb1e66dc83f1ed4671567c13535eecb4242b7e0210519fecc"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5a927626e8e9fe034c1fcb86ac64711163378dd5a38ba947cb2f5777d9bcfb6f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "10afe5b3a32911335e8c1ef6911fe1800d7342abc8b70dcd63338fa750b81973"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b31038195c3d7881f6abc105b7c2f8441a094f414471f8c56bef1165a9a21f2d"
    sha256 cellar: :any_skip_relocation, sonoma:         "a5a87e542d10729fe5b37ee6d114c5eb36cc909e69e358b82154c5a964a3104b"
    sha256 cellar: :any_skip_relocation, ventura:        "3e5f8cb752618386abf077c4e7c0afe07e82606cdcc6ca0cecd687d616eeeba2"
    sha256 cellar: :any_skip_relocation, monterey:       "2ac0a2232a737a83debe6cffdc053c2c9451bd035136811d911faf1283374c04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d4d7247c01d8b85db46cb44f856569782c7d4fe6307e6258c02aa43da4d5460"
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
