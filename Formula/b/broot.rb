class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/refs/tags/v1.36.1.tar.gz"
  sha256 "b52e60a86e3ca38931cf8ed0ccbd4138f12b733c2459ea3088c267a98b8a555b"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a8b8bc87a0bcaeefdfe1c41b677854f9f44628e343a239a4b201e7b7b66c4af4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3b97ebe4b5d69f5ecc55ab323fe3c000a177a4013463ffe6876d3ea82f147e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb01e50119d974e243ef694521b45acc8e01f21dc9de4ebfd6cf4ca87e446fc0"
    sha256 cellar: :any_skip_relocation, sonoma:         "7e9f4ee39c04205198fbc014a3c50a733e7b05a30cf36b0ef193d02f7bd7b965"
    sha256 cellar: :any_skip_relocation, ventura:        "67fe6640bd4548188ba276a7a0952523e0c63932dc27863ecf1c9e07573df335"
    sha256 cellar: :any_skip_relocation, monterey:       "339ecc58db168206e88a717dff133dbacaf34ccc9cca82fb5d40ca06da06bbdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba6ed09a7023ecd262e831b4e3156cc22f96623f78c7709f70e105bbc71806af"
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
