class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.21.1.tar.gz"
  sha256 "0234311ee205ce71fa9ce96c72531495094a485e921dcf0fa29915d88dce3ef2"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ee197a82bbe9a93a6905d4b23454e27dce21828b113ced249afceb364f224cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e379abc626b587d97979ab868b4f9dcf570e8635239f96ef59e8569a28dee54"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "96af6a3cedd5869d84c52a76c22ce02009562375fca86a4a27576f57c6c09164"
    sha256 cellar: :any_skip_relocation, ventura:        "125decba4b26f4af6f66f8b0045a476ac7e315ae1560820ae19f8481794c3de6"
    sha256 cellar: :any_skip_relocation, monterey:       "16ebb07a35402ec5b5dc6ecff4e880e75dda356930cf78ac75219b90901d6cf0"
    sha256 cellar: :any_skip_relocation, big_sur:        "f8ba4197726a3a7cb7e11ee9c364148ef8ea0710f355478d30fcd3d7ce6bb604"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "170654b9653e5cda7cb88a9cac28f189b9db16ea3d1168a520e7de0fcb86469e"
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
