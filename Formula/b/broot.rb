class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/refs/tags/v1.56.2.tar.gz"
  sha256 "3e7be4252c76565f6d71b34bd07d26e1444b9ac2e1c8271c724f6e866fe75565"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c3f44c63c335e67ccbb18d3f434ef53f35f415d454c22756fa5ea70c1cbe257"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b53b0aa9c2a73c86e5fb65cc5a62b1c4feaffdbbd158e29effe1791b77e4a7d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32bf11832c25c8959b9bc0d03a8fdffe4294c4955c64c6b9bd05aad2d54b7744"
    sha256 cellar: :any_skip_relocation, sonoma:        "091053c173bca639071ab5581a5400e9f6c9f15681176712faf850c0858c82cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c65cbf84becefe4628874c041cdb73b6279fd6c2ae8bfafd3a9a2b7073dff7b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "423d9e73268d6a02b0d00c3b45a29e06c84caa66caa55c9f39c1ed3d7d47a74f"
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
