class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/refs/tags/v1.56.4.tar.gz"
  sha256 "ec49422f335965ee0338cd630869eb1fc6d974d43648bd483c802fd7e9aea99b"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1cb6a183257cf0f1ae7d64aa94312dc0039240273692c0fd314c38c5795c9f98"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3e8dc6979119be5f43e84cddafae12a14d55c85dfad60de47049b1f20dead51"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22cf23ad03d1122afb2972ad63ec75c4e973f58cb45da8b93390251b8cabfb3b"
    sha256 cellar: :any_skip_relocation, sonoma:        "4983c937581d0c87c6e2681276cf49fc0fe9f2c596d374a5a45a77d430dc974e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23b25cd8f2df298b35fadc0cc1820ffc017d332fd3128001a0a53f3776503738"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a710b4577e312647bb3d10fb76c66d89cb832d82f5b70186355d34b4f7b6bac8"
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
