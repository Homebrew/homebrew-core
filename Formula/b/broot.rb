class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.26.1.tar.gz"
  sha256 "1cd2e98a9afe8a8d8bed08beaa98bdef0eed0de5d99e38599a59ea0f50d68ac5"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "71d6f6dcf15827e1ab0c340b57fb288c4085f196a44119cf7ef424c55aec1ae2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f528572e6f6b0860acb07872614f7d6b6434db5b329e446eb1a61f995650406f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5e3260f0e9797d5cc0ade4633dfc5107e299abe2d1c62e169f79c6a3f22cef1"
    sha256 cellar: :any_skip_relocation, sonoma:         "158b9c505ac40576fd91eb1eca841cbe68f13ede507b6af116825b83a26eb7d6"
    sha256 cellar: :any_skip_relocation, ventura:        "72872508d3580bd2cf87aebd99acfc4d8ac156bb8fe52e634ed1bf72adf2578c"
    sha256 cellar: :any_skip_relocation, monterey:       "a912db70fc624b2331d896c0df84b63604f3da52a06b64c421d80c3ea2369e8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b4e94729224a86173425b1b4acb19995c8bf97acc82b6cdfb9f652be61759db"
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
