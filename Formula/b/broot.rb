class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/refs/tags/v1.57.0.tar.gz"
  sha256 "28d576f218a92bbb3543124296fb24b40a323b21f586017d073155c44f1cb786"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a02fc825e87ee81b19f6184917c85217000cee934e63907d31527fcb19fdc0a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0fc3bcdd26bb8d5d92ab72c93686717088289cf2789fb759f3b80a1560bc7c45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38b8eef935b48366070335da13f513b0ace8880f22e64e10bc453dd21ef4cff3"
    sha256 cellar: :any_skip_relocation, sonoma:        "444ca89cc21a5dcbcf98483a2594b5e7e7aa1cffd76e668b380b1635436e9cee"
    sha256 cellar: :any,                 arm64_linux:   "39f1643a041cb3850cd02a5ee8bee06a72b43e8e020e307a0e17213d9e5ee4a2"
    sha256 cellar: :any,                 x86_64_linux:  "bdfd4131276d204331494a55696a3f330cec512d6fe42dafbc44d5f9c61151c1"
  end

  depends_on "rust" => :build
  depends_on "libxcb"

  uses_from_macos "curl" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
    bash_completion.install "#{out_dir}/broot.bash" => "broot"
    bash_completion.install "#{out_dir}/br.bash" => "br"
    pwsh_completion.install "#{out_dir}/_broot.ps1"
    pwsh_completion.install "#{out_dir}/_br.ps1"
  end

  test do
    output = shell_output("#{bin}/broot --help")
    assert_match "lets you explore file hierarchies with a tree-like view", output
    assert_match version.to_s, shell_output("#{bin}/broot --version")

    require "pty"
    require "io/console"
    PTY.spawn(bin/"broot", "-c", ":print_tree", "--color", "no", "--outcmd", testpath/"output.txt") do |r, w, pid|
      r.winsize = [20, 80] # broot dependency terminal requires width > 2
      w.write "n\r\n"
      output = ""
      begin
        r.each { |line| output += line }
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
      assert_match "New Configuration files written in", output
      assert_predicate Process::Status.wait(pid), :success?
    end
  end
end
