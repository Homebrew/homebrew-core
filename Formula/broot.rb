class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.16.1.tar.gz"
  sha256 "1eb13f2ff6acb781886a742be43ed5e421fd36eed981806e136bbc8eb63fa63a"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75e8a84c57b2dc1888cd58f79730bfbd79e10c5b3df489118087ad3f85c226af"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a5cc126b318541fa9970b9791c496364e1b4cfa77f5fb6315ff0cc85e43deed8"
    sha256 cellar: :any_skip_relocation, monterey:       "35dd18929f13b8770f3af4f386ef8ebeb4e7527c22c97a67b2c19347d3cd2ecd"
    sha256 cellar: :any_skip_relocation, big_sur:        "943d782920e47084156e1404a57f0bb1786f7b0e2ca62b15de994f0e7cc5ca27"
    sha256 cellar: :any_skip_relocation, catalina:       "fde15b010f9d4d6b3e6df1174504d9d8e06479e10809888ed015cda62627443b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a93a282bf3d6d4fa413d51f5cee1ab78cdbcee84f73e395a802e1e5323d9e707"
  end

  depends_on "rust" => :build
  depends_on "libxcb"

  uses_from_macos "curl" => :build
  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    # Replace man page "#version" and "#date" based on logic in release.sh
    inreplace "man/page" do |s|
      s.gsub! "#version", version
      s.gsub! "#date", time.strftime("%Y/%m/%d")
    end
    man1.install "man/page" => "broot.1"

    # Completion scripts are generated in the crate's build directory,
    # which includes a fingerprint hash. Try to locate it first
    out_dir = Dir["target/release/build/broot-*/out"].first
    bash_completion.install "#{out_dir}/broot.bash"
    bash_completion.install "#{out_dir}/br.bash"
    fish_completion.install "#{out_dir}/broot.fish"
    fish_completion.install "#{out_dir}/br.fish"
    zsh_completion.install "#{out_dir}/_broot"
    zsh_completion.install "#{out_dir}/_br"
  end

  test do
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match "A tree explorer and a customizable launcher", shell_output("#{bin}/broot --help 2>&1")

    require "pty"
    require "io/console"
    PTY.spawn(bin/"broot", "-c", ":print_tree", "--color", "no", "--outcmd", testpath/"output.txt",
                err: :out) do |r, w, pid|
      r.winsize = [20, 80] # broot dependency terminal requires width > 2
      w.write "n\r"
      assert_match "New Configuration files written in", r.read
      Process.wait(pid)
    end
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
