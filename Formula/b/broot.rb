class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/refs/tags/v1.46.5.tar.gz"
  sha256 "730f07fd8450476204878f42c27b1db4f965053c2da5a602eae8f2764c5b92ce"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "deb4f8f5ee11db2d5706ac793129e95ffecb8b6e766423c6c74852fa2478caa2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0941c64d210e6c6e0a775e446aed517f69a6a28f84ae1ba53f5d71bb17c83b88"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0173ef65f3865b4ff8babd2dbdbc82cfaa60f27e5c655c87e3290846362a9d74"
    sha256 cellar: :any_skip_relocation, sonoma:        "b58176de1d90f836f0823c5ded5c0f4b850119ee828e9b96f0e5d9b2d46ad553"
    sha256 cellar: :any_skip_relocation, ventura:       "d1f27fcfd45ffcd9b382ded13e62088e3e26a31b25461e967085522e4d8f7eff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4467d01e9a685274ae894f05199c7e4cc63957e6d102e0a4ff1317f61f2b46b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1728f2acacd355e6d11300f0089d21c4989e7ce21deadd8c9290cc64dc81fd89"
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
