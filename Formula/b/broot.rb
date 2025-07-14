class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/refs/tags/v1.47.0.tar.gz"
  sha256 "25aa9eaefe1ae7b2853325d726cd97d5eeca1a24df35b01b92ee462d88c6a0f1"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed0a15c89810d2eb5d79a8698d1d5ad0b2401e6db88b9896739e12fea30ff91a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bcb12ee6194f60b867809caeb7cb3a8ae1e18163d65fbfafc65a555f786385a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d1c0edd26ab9e0493a075f87b0f9c1f8fe7f59d3896ec1886e1d352eb01df8e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "421ea37b19c3eed9b27a5f8de5534dfa80c3a90de1a7ac46587050ee4530ff1a"
    sha256 cellar: :any_skip_relocation, ventura:       "5fed4c612bfb9a7fa81cf484ef42dd03494775d95ae7b848c95dcd034672f33f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6076d4079b899b405df90427c8294675511fb22c825473726820512b6e7c9494"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a938c83af92cc3f003fe9e66c55b0eaebd7d36b243e4577b1437918eccb2f1fc"
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
