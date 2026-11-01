class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/refs/tags/v1.62.0.tar.gz"
  sha256 "7c3445a6eef45fe67fe2e1f4e0e1f9dca796237d6303615e31b07798cc1716ba"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2630ce850c031adaa5a53d9ba4861ad884ff17391d86393c6fededb44b78c0a8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a3038c6712b3e94246966792f2b705e854a0dbf6dde01842a2fce9cb49f81f49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "54113c83d7fd345e97a07dc4c13d9ea6ac1bc21a50b0dbcc3a7c657a41be9b14"
    sha256 cellar: :any,                 arm64_linux:       "488ac1905f7148db8fe698caedb31684735e3b93fc5762e99a0594e93e47f53b"
    sha256 cellar: :any,                 x86_64_linux:      "b34d0f0214d26d3fbdc456643784a13617f87a831f9ac82b5c47e808d38010d6"
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
