class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/refs/tags/v1.55.0.tar.gz"
  sha256 "3049d055f37bfdc3b2057a3e2186cfdb58b596e1586b6b129698b350a80cfda3"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d96b89249e040c7698aa4df2162affcfa9cd7c53ba829a439afa9695707cece3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db424a506333122caffd1b389ee1b81338d8c74ddf358905bde598190838ecb5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d66c44400c2e5ec13a2d92591e82595d5ada51eb24311ea149c0812e6836cec4"
    sha256 cellar: :any_skip_relocation, sonoma:        "14ff39658185bbbbf3accc4d848b038ff72e8225b0c92e7809c7af6645543078"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74f0ebab5147d0e0b648be28b96e62fe719a7a93b8c4dab8b58ebd5557a4d5a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63b6d9b6287be016a97d08267c85d3bfce54f0f16976ada7733c9209db56d655"
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
