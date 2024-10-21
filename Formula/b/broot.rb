class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/refs/tags/v1.44.1.tar.gz"
  sha256 "f0fe553e89b4173023cd35896ff9f94100b9605a23455a00562ed329962440ae"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4214ca804b43deb2916ca2d6427c6f802eeb917d16b6e85b37da58bdaadd55fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "adeb4d4a9cb8db7bd051730eb627ab8d8e91a10a99a9997b2d4baa7a6580760e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dd86dee631e1fa281b8821c6c63d6b6cc45f11117cb9b0d4916734ed02eb68dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc9da55131b3cc844fcc2b4fcf014d13afac74007d5613f4cf5c38b9326c65c1"
    sha256 cellar: :any_skip_relocation, ventura:       "927304ad739f5b9c3f3a5ed11296e23c75407fc8f579bf9b83565f0105b448ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b93b3d29a4085e09e4cb304e6ae9c8126d8a2630113c9377da52a8895534335"
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
