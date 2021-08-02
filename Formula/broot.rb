class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.6.3.tar.gz"
  sha256 "c7ef696a9da162a4338790a9e021eddedcc9a5be321bfea5cc2c33b2b2a53472"
  license "MIT"
  head "https://github.com/Canop/broot.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ffff0412aed77f5513d4eaa02e47c200c6e6d0154bf3ffc380cf5b9478611752"
    sha256 cellar: :any_skip_relocation, big_sur:       "5e10aad1b7763041cd33b66149452625e2c0f696cc15fcbda429440991e9ccf0"
    sha256 cellar: :any_skip_relocation, catalina:      "01b3aeb78d660f62407ecb655df6b80c158d2ab94dc2e1b36499dc17ea24933f"
    sha256 cellar: :any_skip_relocation, mojave:        "3bd54b8f4927d593a9fa4aa34314be648d3e8347a5f8a3ab59347abd4b525529"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "413fb7222639735cb7264a1cc42f6c71b82195b78a0137b3ccd018500d77eb41"
  end

  depends_on "rust" => :build

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
    on_linux do
      return if ENV["HOMEBREW_GITHUB_ACTIONS"]
    end

    assert_match "A tree explorer and a customizable launcher", shell_output("#{bin}/broot --help 2>&1")

    require "pty"
    require "io/console"
    PTY.spawn(bin/"broot", "--cmd", ":pt", "--color", "no", "--out", testpath/"output.txt", err: :out) do |r, w, pid|
      r.winsize = [20, 80] # broot dependency termimad requires width > 2
      w.write "n\r"
      assert_match "New Configuration file written in", r.read
      Process.wait(pid)
    end
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
