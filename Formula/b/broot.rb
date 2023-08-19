class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.24.2.tar.gz"
  sha256 "cf223710bd75362d37312ef50b4966d57a79b36e3e645f940fd34569075f3974"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dfc73f730b12fa0ede62bc2fc8cf0a6430e37b1383f6169b264e9eb5f884d589"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2791b66ddfbd10dad4ca1eb83ae7ab2f423964311ce329a832129c087f0293ca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bfef35eed802ac73ea98c84d936abf71b3012f837af7359e97283f1f061594ac"
    sha256 cellar: :any_skip_relocation, ventura:        "026067bd98825cf0e2f4ded96e868e5f19621de0893875456146705d9fb02a8b"
    sha256 cellar: :any_skip_relocation, monterey:       "283ebaa802e050746633c9994d62a68f06ff89683c3ce5e9a87c9a7bbb864064"
    sha256 cellar: :any_skip_relocation, big_sur:        "0519b72ec5895438107be4ebd7fdb171de9a42acac6da315c00c3bc5c2c32ded"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a059a28f5b2ffd3c368e022872183ab4d4a8463a7825082d9af39cd0b989d53"
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
