class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/refs/tags/v1.62.0.tar.gz"
  sha256 "7c3445a6eef45fe67fe2e1f4e0e1f9dca796237d6303615e31b07798cc1716ba"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6e7b8f8c8b8fb31dd60a616ddabc33f508b3a60f7013af14cf9fc36a5a80de6e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bd1896313b9f0379c527b84637c60b4c1cc3779a761d2a4a1186631f0871b975"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4fe00ebaff3a29faf5f514df5046d6dbd2bcfe38ee93ec69a5936bc47c54e610"
    sha256 cellar: :any,                 arm64_linux:       "c8b26a0258d7b427f45af81e4fedb070716fbdc59545ec0f5b6d41bcb018d2e5"
    sha256 cellar: :any,                 x86_64_linux:      "7619a57bef21cc9e998885a6b7f63ca7be11c1ea34d4a4cef9b3fb6cbe56b6db"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    # Replace man page "#version" and "#date" based on logic in release.sh
    inreplace "man/page" do |s|
      s.gsub! "#version", version.to_s
      s.gsub! "#date", time.strftime("%Y/%m/%d")
    end
    man1.install "man/page" => "broot.1"

    out_dir = Pathname.glob("target/release/**/broot.bash").first.dirname
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
    assert_match version.to_s, shell_output("#{bin}/broot --version")

    (testpath/"conf.hjson").write "enable_kitty_keyboard: false\n"
    (testpath/"test.txt").write "Homebrew\n"

    require "pty"
    require "io/console"
    PTY.spawn(bin/"broot", "--conf", testpath/"conf.hjson", "-c", ":print_tree", "--color", "no") do |r, _w, pid|
      r.winsize = [20, 80] # broot dependency terminal requires width > 2
      output = ""
      begin
        r.each { |line| output += line }
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
      assert_match "test.txt", output
      assert_predicate Process::Status.wait(pid), :success?
    end
  end
end
