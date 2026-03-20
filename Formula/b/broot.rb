class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/refs/tags/v1.56.0.tar.gz"
  sha256 "05898e481a04b44d4eda575c7b585f26a1f19f5ac7ac06780371453332de4afb"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "29e822186734e773cc3b1dfe008dfb8ce80959ddf28197042f0d1f41af4bd57f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd013fa8d8c6c9e76dc9d459b9d64a0cc98286a915b2616bf459cedc8affe8c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24d094a75d65551047e5cb2b5ee016fe3a25dc437777faf2be2639768fd82570"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2ab9287975765eff6ac7f6aae5367c33bb70eae1bc861ebe71c1d89f6de6c92"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f76a7728d2e6b9e295cf6d6972eff5d3d6dc41bd21bec63944d28a7a18d4613d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f91bd062ac2b07b33c576969dd7ec584d93624d73106a36f7f2e3cbc39e80d6"
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
