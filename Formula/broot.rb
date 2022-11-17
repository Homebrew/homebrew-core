class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.16.2.tar.gz"
  sha256 "5a84bc72e861e9f2e70eb278e0bb26424e249448cf1d67884f419aacc98fec06"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1de96b2754b65b83836a2aa936cd00d3b613968a57d6c923b12effcde953a44e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eea446360ca07eee88ff75447161144d26e70cd5701871f86d776e233be1973e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "039175f91893d590ef526c479c9a0d000abe73ff3122e378f20625ed8093bad1"
    sha256 cellar: :any_skip_relocation, ventura:        "2ccec514d41b191ba70c2b4868415134af31e82d76f8eed03a8520ec0fae01e0"
    sha256 cellar: :any_skip_relocation, monterey:       "685df6399ccb4072a743cc5dc8250efa821c0c12d2a5232b2cb55fc4d7b90e1c"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a05a471763ef89643fb6fd88fe09c837b99b5dc68cdbef64f62efdfc68a5116"
    sha256 cellar: :any_skip_relocation, catalina:       "2cb3c4bfd29e1795fcf5e2d85a0fc51b5b711ee71ba52601ed03a604a6b9c563"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71aeeb3953afb81bc3eca3814efa2453fa4ab14889f80cc3cdf939e195603a56"
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
