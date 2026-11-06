class Goji < Formula
  desc "Lightweight version of Oji text emoticon generator. Rewritten in go"
  homepage "https://github.com/sanriodev/goji"
  url "https://github.com/sanriodev/goji/archive/refs/tags/v1.4.3.tar.gz"
  sha256 "001f77b5fe67cc9c1243977f020b7f6162be0d5cae46b18564048f1f5bafe331"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    require "expect"
    require "json"
    require "pty"

    favorites = testpath/".goji_favorites.json"
    emoticon = /\A\S+ \( \S+ .+ \S+ \) \S+\z/

    # --random: kein TTY nötig, fragt danach per stdin nach (y/n/save)
    output = pipe_output("#{bin}/goji --random", "n\n", 0)
    assert_match emoticon, output[/Random emoji generated: (.+)$/, 1]
    assert_match "Emoji not copied.", output
    refute_path_exists favorites

    saved = Array.new(2) do
      output = pipe_output("#{bin}/goji --random", "save\n", 0)
      assert_match "Emoji saved to favorites!", output
      output[/Random emoji generated: (.+)$/, 1]
    end
    assert_equal saved, JSON.parse(favorites.read)["emojis"].map { |e| e["content"] }

    assert_match "oO:::::::Oo", shell_output("#{bin}/goji --gopher")
    assert_match "unknown flag: --bogus", shell_output("#{bin}/goji --bogus 2>&1", 1)

    # --new und --favorites lesen Tasten direkt von /dev/tty, daher über ein PTY steuern
    ENV["TERM"] = "xterm"
    expect = lambda do |io, pattern|
      io.expect(pattern, 15)&.first || raise("Timeout beim Warten auf #{pattern.inspect}")
    end

    PTY.spawn(bin/"goji", "--new") do |r, w, pid|
      ["left arm", "left eye", "mouth", "right eye", "right arm"].each do |part|
        expect.call(r, /Pick a #{part}:/)
        w.write "\r"
      end
      # expect liest zeichenweise: bis zum Zeilenende warten, sonst endet der Treffer nach dem ersten Zeichen
      line = expect.call(r, /Your custom emoji: [^\r\n]+\r?\n/)
      assert_equal "٩ ( o O o ) ۶", line.dup.force_encoding("UTF-8")[/Your custom emoji: ([^\r\n]+)/, 1]
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end

    PTY.spawn(bin/"goji", "--favorites") do |r, w, pid|
      screen = expect.call(r, /Pick a favorite emoji to copy:/)
      w.write "\e"
      screen += expect.call(r, /Exiting favorites menu\./)
      screen.force_encoding("UTF-8")
      saved.each { |e| assert_includes screen, e }
      Process.wait(pid)
      assert_equal 0, $CHILD_STATUS.exitstatus
    end
  end
end
