class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.8.0.tar.gz"
  sha256 "baa107a2cd458c9f4eda9cafa8fac54570918efafaadfc34df43442f7cd237b9"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99f04a6597dfea881f8838c32fef7946dcfc146a0dcebe12609f67958ea9c1c6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4062bba236a852f7214ecb24b898f0fdad4782d809681cdc0874a30c947c061f"
    sha256 cellar: :any_skip_relocation, monterey:       "276eb98f971691a9a371e09a9959c69ae9fe63aaf0d5b9a71452d8c196b49606"
    sha256 cellar: :any_skip_relocation, big_sur:        "44d89cb87204602e9e0a31e89b3bd1fb744b95ea1281d6a49ede7bc4bc66f2ad"
    sha256 cellar: :any_skip_relocation, catalina:       "cd44f03c29e714ea979b6a22e5d56aa5fa75a4b5205b9dd23bbad303860bb4f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a6d19122f0a302e7376fbaf232f81acdc3d88b110b34abc588cc9c0265cef4c"
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
