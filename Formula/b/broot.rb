class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/refs/tags/v1.37.0.tar.gz"
  sha256 "59335d101b943a7907ceb1ef2d4cf29e755cdf062d3459ebfc294965d4be0e7d"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f90e2b429c84610a0b4734b3af8f651ffcbde8b943ade95424adf62441d96781"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd76e165bbd08086aa9106f447870765da6468a85cff96bb1b78097d80b6dcfe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36959aed839535f59d20d1266b2083708af6d69cb4a3bf91c869206bb6f6188b"
    sha256 cellar: :any_skip_relocation, sonoma:         "9eaea206f64354dce6e6d70b68050a5aa2264cebaa791119ab4e3b62a83cb3aa"
    sha256 cellar: :any_skip_relocation, ventura:        "2224974644d39918526b6b4daf7cc14c4c79a49838614b41d03db956686922f4"
    sha256 cellar: :any_skip_relocation, monterey:       "2b0adf194021f726686483c1795fd79bc1d4187cc3151b46fb4c051ce7248f32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d95db7949d8264c508ba0b63d6a2ae5c4744b84deb777efe2fcaf5fdf20ba26d"
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
    fish_completion.install "#{out_dir}/broot.fish"
    fish_completion.install "#{out_dir}/br.fish"
    zsh_completion.install "#{out_dir}/_broot"
    zsh_completion.install "#{out_dir}/_br"
    # Bash completions are not compatible with Bash 3 so don't use v1 directory.
    # bash: complete: nosort: invalid option name
    # Issue ref: https://github.com/clap-rs/clap/issues/5190
    (share/"bash-completion/completions").install "#{out_dir}/broot.bash" => "broot"
    (share/"bash-completion/completions").install "#{out_dir}/br.bash" => "br"
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
