class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/refs/tags/v1.45.1.tar.gz"
  sha256 "3ce8dcfdc64f03e64547b4413c3d94f47003054aa3e779089393d3e8a7ed3837"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62d85c98412aadc2bd1a699769b987344e65fe9a4a791afb1a57c0d9d3017f3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d3c3a804e45ab882127a91611edab105e05143a7012d8ade12ccffb16a472e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9bb35b92804383340df669363d0fef9551fd97571ec8b8204e37f01857539222"
    sha256 cellar: :any_skip_relocation, sonoma:        "556717270fcc451408eab99360a9e6103c37c89d59d36d6676e2827c102075fd"
    sha256 cellar: :any_skip_relocation, ventura:       "f524d9ea25249b699603aea7fad1bca8b68845ff0061c5b5f896a2751ffd98fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2105de7fed1d8b5a0cdc14dd9191d59d5c26a9491486ccb003de8cbf777c8684"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3354a07a72b42afe300bab20bd36a811a23c39e1636da38dc18e9da7b03753f9"
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
