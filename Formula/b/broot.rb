class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.25.0.tar.gz"
  sha256 "5b34f7e975e6bbf954f81f87af720559aa6a5916950275242d43fade906f20b1"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d87ad41ad03734dc15add1cdb15ab7245d782822e1c27319f07bf600d9006912"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b942a94b96c3bd201eaf9af1254608db44defa9a8b5cd2d463d06e0d1a1a23a7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "52bfb9dee116090877e95d63b9ea027f717523a7b5bd62a608721df0a2e42a82"
    sha256 cellar: :any_skip_relocation, ventura:        "e936fe8c84ba196690c5c99ef81cec5e0956e8e6d20847a956064daa380adac6"
    sha256 cellar: :any_skip_relocation, monterey:       "c9a36460045b0f3eb3a34f1faf905341d94e5281335b40d32579b54936694746"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d8151e9b3cbd3e5efe67433cc7842549b9ebcc9d73908a6f24bd2f7f03fc617"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4dcf1a38d177df448803e26ae94a3724e5cf2b02ab799672439a9ae0438b20c3"
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
