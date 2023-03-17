class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.21.0.tar.gz"
  sha256 "8834d841d5129cc24ee59ffd97bee6f11d5145d2104bbf248f066ab5dafb7407"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4010080fb4ff71edd20719f13139f142aa45cdf7a1a70e696914e6b2cde4cace"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "982b9a0dcdc6c0825a16c2fc700e4ce39f9fc35bd02b3592797d7fcc50b95670"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f8e6e44a9e25e4e2c6433b62d5578489784c1640846fd1d8f51b26b38a4fe386"
    sha256 cellar: :any_skip_relocation, ventura:        "9ea28975dc5ca2dbf6fdd8d3e37c71528ad694c82804d2826b49a199a4a1099d"
    sha256 cellar: :any_skip_relocation, monterey:       "85849c8d56aaa4d83dbc9228cd1f14e24b45c8379e6ea2c4646e6f32e8e9c0da"
    sha256 cellar: :any_skip_relocation, big_sur:        "76f00e14b79306d14ec7b59a1e7a29162af662527f50d8ef79cdb1c25dd28ec1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d42af15a31134838b324ed933dacb1ad43960234fa6c2b3f8236cf56d59654c"
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
