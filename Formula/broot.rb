class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.22.1.tar.gz"
  sha256 "cc133b7d8f9430178309f97252a39466cb44d704cbcaa7333508ba519d1c1815"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "81cbe30040785994fdb85520dbde4621af0a22a2a6381a1ce8b3bf8f7d72537a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d081650cfc341a9adee67bfa02390750891b71c2573b9ccc6880fa5fac2e98a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "419177f34e3e71c25a27500db4279f2fe18bdd5a18dd6e497d065fe22978ea53"
    sha256 cellar: :any_skip_relocation, ventura:        "f84c123336247ec7c9dcbab3161689686863bff2648c06451e2189f05dc4e644"
    sha256 cellar: :any_skip_relocation, monterey:       "da0ca631b4b0ba0ea7f30fc1703826ef46bc47d0f32191c0bccc3bec99dc0bdb"
    sha256 cellar: :any_skip_relocation, big_sur:        "63b30bb4ed3e86e25109052d8ab3240cc8a4a32eba98fa340ad6256fae918c3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba43a9b7528fb2c51313396af710c8503f785badb40994031cc2e836a70ef99c"
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
