class Csvlens < Formula
  desc "Command-line CSV file viewer"
  homepage "https://github.com/YS-L/csvlens"
  url "https://github.com/YS-L/csvlens/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "4c327487eb9958ba089c68748e224533e53f8d7066ccc43a21f51ccd0e44dee0"
  license "MIT"
  head "https://github.com/YS-L/csvlens.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
<<<<<<< HEAD
    require "pty"
    (testpath/"test.csv").write <<~EOS
      a,b
      1,2
    EOS

    expected = <<~EXPECTED.chomp
    ────────────────────────ab───┬────────────┬───────1│1    2    │││││││││││││││││││││││││││││││││││││││││││││││││││││││││││││││││││││││││││││││││││││││││││││││││││││││││││││││││││││││││││││││││││││││││││││││││││││───┴────────────┴───────
    EXPECTED
    expected += String(testpath/"test.csv")[0, 24]

    PTY.spawn(bin/"csvlens", testpath/"test.csv") do |r, w, _pid|
      r.winsize = [80, 24]
      sleep 1
      w.write "q"

      # remove ANSI escape sequences
      output = r.read.gsub(/\e\[[?0-9;]*[a-zA-Z]/, "")
      assert_equal expected, output
    end
  end
end
