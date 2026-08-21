class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/refs/tags/v1.58.0.tar.gz"
  sha256 "2e61f7cddafa39417ff1484d24773190c6a472975a400204d901080a6335a652"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f3c7cb112ce85956a752051d3b0c33fcf61fc9255403124d87c60f0a37df6c47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "597a7ca71f26b50c438eb432a64d0c373d3036d91e0883616f5af574b3e7f2bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd6515c48cf9c45d2ed84a2070a658d7c2c49a3abdce2b2968b38377113dfcd0"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ad2f08c01bace8e8e6caa385add75da58250f0aec9b54cb545b1229ecf85c57"
    sha256 cellar: :any,                 arm64_linux:   "8db97613a3c2b2bfee53543016c493542b2199cc7514dc3d6d081f13ff66e269"
    sha256 cellar: :any,                 x86_64_linux:  "b2b5159109e53a9b52f0e783439dc7dcaaa96215b28ac2a69af0fdf8dd9a8570"
  end

  depends_on "rust" => :build
  depends_on "libxcb"

  uses_from_macos "curl" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
    pwsh_completion.install "#{out_dir}/_broot.ps1"
    pwsh_completion.install "#{out_dir}/_br.ps1"
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
