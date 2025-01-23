class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/refs/tags/v1.44.6.tar.gz"
  sha256 "554abc12c8343a0e921f92740e06bf3a86993f71eb78246c9b494293da13b1df"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "689b3bb4b6145531dcfe0b0d2d7bb5206da9de775eaaff6611a72bf089ee8373"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "714f513f224fe58704c14545fec65288818c92288f8535779389c734bc446dba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "020284e80923e0881768b34c8d1a012a358fe833d7bed1494b07fc5255e3ce98"
    sha256 cellar: :any_skip_relocation, sonoma:        "a86d8a7b04255aca8e690b989ce4f417a0dcca5811b8354dcd422cb2696e0053"
    sha256 cellar: :any_skip_relocation, ventura:       "d708e233c0ace8adfb6d2f0a748fe18d45b169db2b35f176a3d4fc2de65aa9b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a96b658660d581b379edb452b7f87796c075048962a17fab15f723830cf5f4f1"
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
    bash_completion.install "#{out_dir}/broot.bash" => "broot"
    bash_completion.install "#{out_dir}/br.bash" => "br"
  end

  test do
    output = shell_output("#{bin}/broot --help")
    assert_match "lets you explore file hierarchies with a tree-like view", output
    assert_match version.to_s, shell_output("#{bin}/broot --version")

    require "pty"
    require "io/console"
    PTY.spawn(bin/"broot", "-c", ":print_tree", "--color", "no", "--outcmd", testpath/"output.txt") do |r, w, pid|
      r.winsize = [20, 80] # broot dependency terminal requires width > 2
      w.write "n\r"
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
