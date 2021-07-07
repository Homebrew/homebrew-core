class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.6.1.tar.gz"
  sha256 "5f97d876aa554be4c67bfd161ef762425f6083da583775c13cc75bf9882f1085"
  license "MIT"
  head "https://github.com/Canop/broot.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c92f48f3b8e4e9d7c81389263c6be05ce6976129e3582173580b2f7ea37e9758"
    sha256 cellar: :any_skip_relocation, big_sur:       "b26055e7a5ba7759e05d5964c7f1cafb3d57d5e2d4ee695c77dc7e764a087f36"
    sha256 cellar: :any_skip_relocation, catalina:      "15189da6c77fff1a516b46771b2c54400a7e570e22dc9abd853e5c9a47c443fd"
    sha256 cellar: :any_skip_relocation, mojave:        "e54a687ab10f4a4cec43ee6ef7b63a0273a1b38e12b92744d91c98e756e8fc3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7672fd69a560f3403a3e40740928f8c1a31daf5d7e8c656377d371d296de4d83"
  end

  depends_on "rust" => :build

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
    on_linux do
      return if ENV["HOMEBREW_GITHUB_ACTIONS"]
    end

    assert_match "A tree explorer and a customizable launcher", shell_output("#{bin}/broot --help 2>&1")

    require "pty"
    require "io/console"
    PTY.spawn(bin/"broot", "--cmd", ":pt", "--color", "no", "--out", testpath/"output.txt", err: :out) do |r, w, pid|
      r.winsize = [20, 80] # broot dependency termimad requires width > 2
      w.write "n\r"
      assert_match "New Configuration file written in", r.read
      Process.wait(pid)
    end
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
