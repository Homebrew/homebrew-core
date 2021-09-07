class Murex < Formula
  desc "Bash-like shell designed for greater command-line productivity and safer scripts"
  homepage "https://murex.rocks"
  url "https://github.com/lmorg/murex/archive/v2.2.1200.tar.gz"
  sha256 "0f0ab62c5bc85eaf440b4a68135253c7dbc1ef264bc32cead4bc0c1fc0b8d0a2"
  license "GPL-2.0-only"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    system "#{bin}/murex", "--run-tests"
    assert_equal "homebrew", shell_output("#{bin}/murex -c 'echo homebrew'").chomp
  end
end
