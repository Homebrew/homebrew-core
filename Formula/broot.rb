class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.20.1.tar.gz"
  sha256 "7a6fc5f657cab0f5a90c2fa0705d61371edeaa7f92cc7674292f48d4258c7ed1"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a7cd7cbedb351448e35e853ac5b14065fddb14b9ddc08edde8742d2b764219c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a16fe5b905add096c6f476ba82cb64e6f28ee2fe2c801eb9609537c6fbdf5ba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ebf1486d3a258370eee3189d68c28756b84712e368b46a4ac6bb0baa968b2233"
    sha256 cellar: :any_skip_relocation, ventura:        "99b7e3ccca387354a16f1d74f7df704b9b06045ae61dbd16cf062f82fc820c55"
    sha256 cellar: :any_skip_relocation, monterey:       "e8a6518d9836faee9d53853a5f4dde27d8a388ba192673aa16288dbbe1c6fbdc"
    sha256 cellar: :any_skip_relocation, big_sur:        "075ad5e0480c9db38e0075eafd213357e98955d128f604b47104dee7555ded5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "901eab066514f51b7bd2b5250896a545447542483dfa0691c2d34a80cde6b9d3"
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
