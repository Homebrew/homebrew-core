class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/refs/tags/v1.42.0.tar.gz"
  sha256 "f8a206d44b55287f47cdb63e2f19c9022d55d49f9399e5461f7797ccbe0264ba"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b6aaaa41e3f935d59ae7591bca1d107e6c85e61778f3e0a044a622363364c51e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c9ccbae2b90e8945ebfcbeda1d8c0b1045b6606b76ca1733ea1497d33757a7d3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "316aea9a99b68ddc2ef6b6fb0aad6ff34c90f214d25fdcfad3836848ae84cc97"
    sha256 cellar: :any_skip_relocation, sonoma:         "ef63ec076c04bbae088aacac423113f3df309af8117c3a95350ff702d359afa5"
    sha256 cellar: :any_skip_relocation, ventura:        "a3abee22af7b544012d9bcd6310bd1ab9c7f3cb8541e11bdc48b4d441516a028"
    sha256 cellar: :any_skip_relocation, monterey:       "77ee5bfd89bd473c10170fdd3c5f05b337684d4d6804f525cc8d3fd314040b39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f40673935c1bc1ec57ac825a0e84ff911579cb63cb92d03f71bdbf307d0428d"
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
