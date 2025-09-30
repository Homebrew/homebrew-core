class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/refs/tags/v1.50.0.tar.gz"
  sha256 "096629487fbbca428ae8e59597e6af2eb41ef23c472aeba2c289b06105a1a924"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fdb038a94f8c9d820a67c665bcedd1bab422e0c84f16887f1ac72e98fcbd8098"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fae54a23b5de8191aa723de06f3cb0ad31c6082e8df0f4862223273773a26b0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ac767db5ea356b6c9e622429986edfad0bab2d6815c29efa2d758d5915b4cea"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ee0cfd37337746be31918ab03ea5edc2f151aa4d5acabf043435808bf594666"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e1e16f47313f318a70038636e1db6546de758b5d9e35b85eef09610bacb1601"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3254550aacec3f556b576518e6406802c283f8d1d17f8930ce51e7a8bf5bc42"
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
