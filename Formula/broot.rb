class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.17.1.tar.gz"
  sha256 "acde4ddfff0875506c4f91346895c5b554d44a91f46a6918de6086d3884857d7"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "01fb2a18fe70a97990a63ca59375fe157bd21bae6a6f36f15483eba16b784354"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef44a44162b433debf790023d251f7815db05093d5eccefbb3818f0a3a99df60"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "648c724ad746e281328a21d2c812158e80b0108af4a51681211e00f18b3cb9fa"
    sha256 cellar: :any_skip_relocation, ventura:        "b6a549eb6a3ae3cb06e7cd505894bfeb5a72c3a9923a027fe36500213b3e2804"
    sha256 cellar: :any_skip_relocation, monterey:       "6cefcada912c3e8e5628c3c89830282ad444cca43f2451359e21f5d86fd057ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "568e1a69e1232d4fd9a37a3db96091d51282fa47ac256139acff04afcc454775"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0d8389685c52e75de6f403e19763316929f1dc8704dc950505b844daa6e4e07"
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
