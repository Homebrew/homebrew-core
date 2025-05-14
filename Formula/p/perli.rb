class Perli < Formula
  desc "Multi-platform Perl REPL"
  homepage "https://github.com/mklement0/perli"
  url "https://github.com/mklement0/perli/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "210be26bdd6f8e84948d3a1366d3908e06c518684714dd99ca343fdca01ae329"
  license "MIT"

  depends_on "rlwrap"

  uses_from_macos "perl"

  def install
    bin.install "bin/perli"
    man1.install "man/perli.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/perli --version")

    require "pty"

    PTY.spawn(bin/"perli") do |r, w, _pid|
      r.winsize = [80, 60]
      w.write "'br' . 'ew'\nexit\n"

      assert_match "'brew'", r.read
    end
  end
end
