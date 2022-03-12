class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.9.4.tar.gz"
  sha256 "f1a3cda2ebb3a436b039cb2296914871599305f7f9292cc53d3641a67706fe9f"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd380ae78256ba55b0cd76e5f4791fc8c20436bb5a917b261ef030b5559bf33d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee9d7f6a39348613611c48e7d7256a18f873fedea2403ebe3545510cd9ad1cfd"
    sha256 cellar: :any_skip_relocation, monterey:       "3078be49db2380e4c6ddf3dbc86273657aa4160e8c2060e8e5d9d4fd140dce40"
    sha256 cellar: :any_skip_relocation, big_sur:        "5df598cbbe460896225cef3f979ad755f4cf2d4a0e4830df19c1149637b15ac7"
    sha256 cellar: :any_skip_relocation, catalina:       "191f1bb5af12cd2286ee35bc41b65ed286609475d44bbe5cc489b9de73aed553"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aef770e0bc4520c0aef5d577abb628065f20681d14762e45ffbf2a44defed262"
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
