class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/refs/tags/v1.34.0.tar.gz"
  sha256 "a1a8e6f01abc135e587fc50664b38c58e1ee86203dcb7df1a1ab4f9b371b39c8"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "66a915b60d547e20bb41b124859c7c278c6866f39a1e6f560c951ec927d52959"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "713638c593b4f0e9609e6f8462dd325757c59f27f4f7c772c2dfcc3d91ae6eb9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7976e856e3aaa440e346d812a599d06c8a893cc6658653b57a8e693e36cef236"
    sha256 cellar: :any_skip_relocation, sonoma:         "188e68a5a8a347fd3c8f519b1795350f7cc75e1ddb450282440d4b7c69f76ec4"
    sha256 cellar: :any_skip_relocation, ventura:        "79a74e8e17763ecb0a0ed846fa1ab02e1b567708ab531e9552fe01d250210d1c"
    sha256 cellar: :any_skip_relocation, monterey:       "c602f49dc7ffec08a0a0b8fe7e43e964d5245885b8b2f8f5c94e92ffa1897315"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cad98e87d5870dfe014ad46b80e830d96f33cc1527cfae0e384adc9538717355"
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
