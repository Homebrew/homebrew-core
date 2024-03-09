class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/refs/tags/v1.36.0.tar.gz"
  sha256 "2929d18c2398afa073f170941a45cd8ab4693d272e1c487c95f7e527569cda99"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dcd5cdba77350f185c87cb90b8aa3532096368e1a544a00b9cece5c716861437"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c4956a037b8795d0bed351e21be38dcea56803fdb653905324883f7e8262dd2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36457f28cb0ec606e60b2206051b57820723472fab2199cac8bf5bfbb326bacc"
    sha256 cellar: :any_skip_relocation, sonoma:         "3faf97e55b8b662863ea54d5fa92ce02bb61c80933a534f37698bcc113d98165"
    sha256 cellar: :any_skip_relocation, ventura:        "5c40e7d2ec7dfe8e3015b1965a001785a8a6c51f07cc0185fb7f27d81c01446b"
    sha256 cellar: :any_skip_relocation, monterey:       "e90a3bd735130f0ea7fae631ceee9eda0548f95a4acec830142edcaf2fc178f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f33b4378913a121f977b5de63d0a234885d29f15b6b893a112c454873bd79db0"
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
