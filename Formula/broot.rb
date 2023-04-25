class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.21.2.tar.gz"
  sha256 "492806ffa225f74025120a353a40c89d08c1b2b2ce2d5f0a412dca47f21f28e3"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "52572c9f11f219fdc56d26a6dc2cec54b82582c5460bbce943ad8e336c718189"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "645d7e46d80e1152a266593e9e97bffc441d1f4d1a688c02a007d8bd8e5794aa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eed6b719fc135e04995467da6d4a6b94a54ececac8fc40a16798c5423a2e4507"
    sha256 cellar: :any_skip_relocation, ventura:        "87c0aad2d7e055368c2a8069966897afc12ee5e743d1317a2d7cc08818b91a88"
    sha256 cellar: :any_skip_relocation, monterey:       "d296bbd2d84e453aae08b657cd7611dd47c2d5ff971b0f3b839a3315bdc032cb"
    sha256 cellar: :any_skip_relocation, big_sur:        "1235d5174787747d12e9748f086a1e789b4d5205dc165dee3ac50f74810e875a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3d0c8de0c7ab8aea9a178002099ef9fcbe738da454775bf647550b72f1e9b7c"
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
