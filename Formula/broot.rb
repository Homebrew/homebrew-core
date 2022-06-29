class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.13.3.tar.gz"
  sha256 "a7f9e98ff1371eff065a8dabbe9e31ef42d264b7d93c18f920d6a5399016da33"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd4f0372154e765494f3bef5366ea2ee88c2c77db65d7176fd2d4093eaab685d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "39170b43706bb7f77791c12e1d90861f266d9bcfeba4676323d72a6665694743"
    sha256 cellar: :any_skip_relocation, monterey:       "a57a31314f2b3dd0cad112eed17482c36b5016e949c5491ef3f44223293de3e5"
    sha256 cellar: :any_skip_relocation, big_sur:        "ac048591937849d7a909da9c2c5ee1431864180503520c6d41a11e8abd7080bd"
    sha256 cellar: :any_skip_relocation, catalina:       "380d2bcc152407341e4733f3885fb0aab0983c5db6c89bb126f16d3ea83f1a15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc671fb4e153e05f39b747eead78e8a0f3464663f22b41f50d47c0ca7746256b"
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
      assert_match "New Configuration file written in", r.read
      Process.wait(pid)
    end
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
