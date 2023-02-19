class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.20.2.tar.gz"
  sha256 "372623ac1affc2473bcf75ce6be2862d8cc61ac4372a622a599b4c7f2ea06161"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c1db8d4f5d248f7aa15ba5deb03b968f9ed36f1623a97f71fb137577959cc63c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3db01df1206f601fb7a1e7d4d4c95da4624b469edf7818bdfaa4d938b7289f98"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a0715e3e29624483379a91ada993ec108a5db807e4708980adc342af417cf069"
    sha256 cellar: :any_skip_relocation, ventura:        "89c9cbf4ef398bfbf1a39a042585ad590d2f915c3bf49ac234b8302cabdebec9"
    sha256 cellar: :any_skip_relocation, monterey:       "d455c7a634c6b9ca16f17176ad651dd5111abbcf4a4b32e1fa9b0155c4fc1c77"
    sha256 cellar: :any_skip_relocation, big_sur:        "762db7912c375d8a729f524612c124a113c4eea363a6654d10abec0950781f78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "caad6e136dc15d0f9e8ed823622fdbe5e2ee2dce70aa3bebea0fa4af2932df55"
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
