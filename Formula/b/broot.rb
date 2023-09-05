class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.25.1.tar.gz"
  sha256 "5dcde6c0335f0f291f2f3d1266f743434f38687c2a4f457fe9c5fd03a2ad407c"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c0a3acbf2075c8189785f251e9427ee32b530c71846dd00e357594716c1e72b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "348a62dd39e0e9b0c175933c94cc2fd940016f3abca60061d18d392c664f4f68"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "637088b4656c32388d57b574ccb3534291d45eae6779320cdd80456cda86fcc7"
    sha256 cellar: :any_skip_relocation, ventura:        "bd494aeadff08da7fd0a49ce13b52c06b4c19288713d0a24eae8588ea8f54f5b"
    sha256 cellar: :any_skip_relocation, monterey:       "689b344bb29155e67e4a2731730896236a30cf7817fa20cdddfeb2f072bb6ed0"
    sha256 cellar: :any_skip_relocation, big_sur:        "2eea703ffef0d05a62a36ee8a92c447c46c8f934f724aa06cd282a73f92e9b0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2a95147036dcdceccf12d24c5871e4371043b76f2e74005426294a4b23cbba1"
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
    bash_completion.install "#{out_dir}/broot.bash"
    bash_completion.install "#{out_dir}/br.bash"
    fish_completion.install "#{out_dir}/broot.fish"
    fish_completion.install "#{out_dir}/br.fish"
    zsh_completion.install "#{out_dir}/_broot"
    zsh_completion.install "#{out_dir}/_br"
  end

  test do
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    output = shell_output("#{bin}/broot --help")
    assert_match "lets you explore file hierarchies with a tree-like view", output

    assert_match version.to_s, shell_output("#{bin}/broot --version")

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
