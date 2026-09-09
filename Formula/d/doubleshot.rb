class Doubleshot < Formula
  desc "Caffeinate-style CLI for closed-lid Mac sessions with automatic cleanup"
  homepage "https://github.com/jonathantybirk/doubleshot"
  url "https://github.com/jonathantybirk/doubleshot/releases/download/v0.1.0/doubleshot-0.1.0.tar.gz"
  sha256 "8fadbbeeb1c4fc94aea3c32e6ec72e4a7d5bc7537d8ac6695a96bc98ff033c39"
  license "MIT"

  depends_on :macos
  on_macos do
    depends_on macos: :sonoma
  end

  def install
    system "make", "CC=#{ENV.cc}"
    bin.install "build/dshot"
    bin.install_symlink "dshot" => "doubleshot"
    man1.install "share/dshot.1"
    man1.install_symlink "dshot.1" => "doubleshot.1"
  end

  def caveats
    <<~EOS
      Run dshot to begin. First-run setup asks for administrator authentication.

      Before uninstalling this formula, remove the service with:
        dshot uninstall
    EOS
  end

  test do
    assert_equal shell_output("#{bin}/dshot --help"), shell_output("#{bin}/doubleshot --help")
    assert_match "Doubleshot 0.1.0", shell_output("#{bin}/doubleshot --version")
    %w[dshot doubleshot].each do |command|
      assert_match "invalid -t value", shell_output("#{bin}/#{command} -t invalid 2>&1", 2)
    end
  end
end
