class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/refs/tags/v1.38.0.tar.gz"
  sha256 "1805d8acbf5b31124370a19c1f855a50c7fb929359ef689d9b68957bd95aa000"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "97c60892bfe8300b19180e4d6fc649324ece783dc62632f77a2cf8d9187a4908"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "819d98dde6bb37da8bd25cfd2dc3170e15e125f121cf264560b1cb0f774d096e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5db744b68ab5766878334f122154d2f86f8e252feb0f8a37c00befecba2f7dae"
    sha256 cellar: :any_skip_relocation, sonoma:         "c1f69612aaa7af04cbbceb9eeb07cb193eb9aac30dd98382b597323fbb805ac2"
    sha256 cellar: :any_skip_relocation, ventura:        "6afae2ed8b86e085f21c60f5a23d04c9b1fe19f8a9c9b3d151c0e2c826dd77da"
    sha256 cellar: :any_skip_relocation, monterey:       "70f9589190959efd0fe540ea0945329f31945ee09356075e1d1fee75cd87ca62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3987c115a7e354b4a14b6f9aac29e6546d7e1a2e89093b930f57cfd05848009a"
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
