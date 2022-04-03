class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.11.0.tar.gz"
  sha256 "8273587cada352d87e30db3c8d07c14d6cf46629ef821e6182bd086eca351504"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f66e9eeae2d5dccc909877d8ddbe0644cf823752de8f93c8e9a4e506ec73929"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "90f22a4c559a7178701e9331da02aec463a12ec20979a5f84154205b15c48413"
    sha256 cellar: :any_skip_relocation, monterey:       "3cf09a69b079de8dff9689bc34d6d615e3b8def4023d237189ccaa9a1986f28a"
    sha256 cellar: :any_skip_relocation, big_sur:        "886f7effa0604515ddf0e8a3312384a076f059c4f54901b20c02b7d9ff4720ad"
    sha256 cellar: :any_skip_relocation, catalina:       "20fa7480fb2c777a847aadce895c6e2e381fc902a85b1e8c8ffd2a254f52760d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc8ed6f7cc8bc23498be91cb02f55a7f350b7a5ecde1d8fa06ce123d02ae6c6b"
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
    PTY.spawn(bin/"broot", "--cmd", ":pt", "--color", "no", "--out", testpath/"output.txt", err: :out) do |r, w, pid|
      r.winsize = [20, 80] # broot dependency termimad requires width > 2
      w.write "n\r"
      assert_match "New Configuration file written in", r.read
      Process.wait(pid)
    end
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
