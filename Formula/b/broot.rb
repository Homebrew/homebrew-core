class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/refs/tags/v1.46.3.tar.gz"
  sha256 "c09a3740c1e2f18ad9159c78fc31c70900bb72069d918e90cff44b6139316492"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9f19a8e58bc1230820839e01acb459ef6a768839e217d3d2cc7c7e6006b2034"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1e051ca383c6d81b597f4a5021735e18a6269a431e58e473e0d712e7f7d2d7c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "853f511d7dd1b2b5a89c98830434bb7fbae5895d0ebcb99e9b8a0c3c72066eb8"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a09ce8f7f97f9586a19c9c143be76130d4c3eceab94ad7803bb8af3811f0ad7"
    sha256 cellar: :any_skip_relocation, ventura:       "019d357134b57bba980be77ca7e5ebb7111e929690bbd704eccf61756c532f9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4775fdcc3530483d6d0d401d184c82e229651ad0e229d98a351f51c7a4e20ea9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d1525ff9bdcc8cc0733020fc9a471a2292882a0db0f28e38bcdc33f80d14728"
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
    bash_completion.install "#{out_dir}/broot.bash" => "broot"
    bash_completion.install "#{out_dir}/br.bash" => "br"
  end

  test do
    output = shell_output("#{bin}/broot --help")
    assert_match "lets you explore file hierarchies with a tree-like view", output
    assert_match version.to_s, shell_output("#{bin}/broot --version")

    require "pty"
    require "io/console"
    PTY.spawn(bin/"broot", "-c", ":print_tree", "--color", "no", "--outcmd", testpath/"output.txt") do |r, w, pid|
      r.winsize = [20, 80] # broot dependency terminal requires width > 2
      w.write "n\r\n"
      output = ""
      begin
        r.each { |line| output += line }
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
      assert_match "New Configuration files written in", output
      assert_predicate Process::Status.wait(pid), :success?
    end
  end
end
