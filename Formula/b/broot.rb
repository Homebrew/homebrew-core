class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.25.2.tar.gz"
  sha256 "1c15b11133522a42b547a6010e7ab7edf9644b7755361aa346eafc143a477ebc"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "662e51ead8e62d50b4f08ca404308ab77e15c198a18a5d73d2af94c6dcda7c26"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8737517572f7ef5e9bfd5854e77c17bd85bd6346f74b7bcae427f402ea4462bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7658dd8d40d9575b24233b46e5e300f2243fe22e4b69c8940a6068d83d8c5aec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "56ccf4ab3ac9fa25213b7817d926e158a67c6e6df870443efdf5a564213d157c"
    sha256 cellar: :any_skip_relocation, sonoma:         "b258debf7296cbdd3dd7da0edc7f97b5d7e9608f2ae276c6e6ce4793b220d326"
    sha256 cellar: :any_skip_relocation, ventura:        "76e83a230eda3358dd9d2f9a1f9c251320aee13c9bf7c9d0e3f9facf307df266"
    sha256 cellar: :any_skip_relocation, monterey:       "fca9cecc49b283f4be49461c5ef12a6342bc823f0bbb263a3e5bd51db7e51339"
    sha256 cellar: :any_skip_relocation, big_sur:        "3c3cda1692867514f503e7375fb92acb243973c440c0a2812dfb85c8c2c9206c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "815b162d8e2b9a3cd516a42401b934d1a3e3bc189cd4ddb85016aee8cd7188e7"
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
    bash_completion.install "#{out_dir}/broot.bash"
    bash_completion.install "#{out_dir}/br.bash"
    fish_completion.install "#{out_dir}/broot.fish"
    fish_completion.install "#{out_dir}/br.fish"
    zsh_completion.install "#{out_dir}/_broot"
    zsh_completion.install "#{out_dir}/_br"
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
