class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/refs/tags/v1.53.0.tar.gz"
  sha256 "cd675a81222ac82a238778325a51e3f14b971df32ceedf9bb892f3a1d012e10e"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0dde95dd419b8c751a42ef4e834353555416fb8f6344ee59fab239f4dff51ba4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a560003be16d6cbde80d9075d2f25cb1803cba3294e394a953aa50eeb9f3a34e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3c3b688c6c9583f4b2e565e482d9411c635515a5d22b48e0172057a7b1f056d"
    sha256 cellar: :any_skip_relocation, sonoma:        "01a91b60c918da6cbe61c0cc2a3ff7ee820d9a980977ee0ddb233457769378df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e6411f8ad43828776304c36ee97ae63da95b3b2f588944e084d5b9dbe5a7c3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aac1a0b8d68830c890fbe02168875038cd2721b39b44036c27a2458d205f2382"
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
