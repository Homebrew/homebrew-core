class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/refs/tags/v1.56.1.tar.gz"
  sha256 "0d29cd855b7a0de5de3d3c191ff43ed9d447f7097c6ca40abc0686d539a9923c"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6bc7fa9333762ea645e18619ae85c999874ebb3dd5dd47e0847c1987e8cfe88e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed4f5d09bc605d510053eee00a177960eaa476f02592f07208e490b8865bc005"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab3c2d19a7b430b820b6e37c2715337ccc4391d6a3bc035b29b7d9dbf270f1b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "416c87591d41979f6bed1211a73b2947c9d2025ef6753edb24f6acb8a7c2644c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9cc14711fdd7a4b31f87f5f425a39ce84db7617dcc63acf2f5dd517191ca22e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b36fed84e5b3e1a2e301000484818c3f5746d618f65a04e938ffef6cb630a39"
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
