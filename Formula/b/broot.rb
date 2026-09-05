class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/refs/tags/v1.60.0.tar.gz"
  sha256 "94b3b6f3aaa59dbd7824175f63b298e93e03cc157b02662e83427a61e14b37aa"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f816b17745e51902d867bf924afb052bb19df6bb418a305d51eaffb7c31eebde"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "500676f26ee0a0d2bd93e65a7ef7c3a870c1885a6f0fc81808317ca696b7f6d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe7132a62188856f58d0cea8279c6e9c706609ba891d5c788ccdddb0895cc025"
    sha256 cellar: :any_skip_relocation, sonoma:        "1540c4a568ae76457b86e770e05b8f2e9c4f290e3e23b41b22d4fe4ecf5f0088"
    sha256 cellar: :any,                 arm64_linux:   "0daa8649ee3a14ebaf81034f92a1c43905ea59362f8fdcd637eeced7f4d5eda3"
    sha256 cellar: :any,                 x86_64_linux:  "90b0ca3bf48a34d578de2ff84b2e7a6e85c55f5ed4b923f1a93a5d5e7d4d4ebb"
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
