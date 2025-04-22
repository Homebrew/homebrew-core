class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/refs/tags/v1.46.2.tar.gz"
  sha256 "379c83e197c56998e4496a981805182cbb6216867253568b858afd33fdd3847a"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3755906766f6074f58ae8c074227c6954077779246f50d7a55d35c92f46d77ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "855bddd2fef6817cd041a3f3a07017f3a8d298022b596e67e9370976706e943f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ac9e85c613b2ef3a6139e3bb075fbf943ab0c9444571089eb8b3ec3f35f1174b"
    sha256 cellar: :any_skip_relocation, sonoma:        "433aff77106615b4d762e77b4220b062d89514baf824a622059e50a9947cdb98"
    sha256 cellar: :any_skip_relocation, ventura:       "9066bc479fb65e8850f58bb7bbffc61543a352b4c0d755cc35cdd8282cb4df27"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62278432605e46d4cdbd47028ad459dbd53c9f24faefe8d9832229740d9923f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49159b82ad22a236f491efcf3685159990a954650dfbbd3fba89054670e65297"
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
