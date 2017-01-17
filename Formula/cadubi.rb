class Cadubi < Formula
  desc "Creative ASCII drawing utility"
  homepage "https://github.com/statico/cadubi/"
  url "https://github.com/statico/cadubi/archive/v1.3.3.tar.gz"
  sha256 "79af56d5d659e28306ea07741e3ad97d5f0e6e9db7a5b0b632a9c21b87f6324a"

  bottle :unneeded

  def install
    inreplace "cadubi", "$Bin/help.txt", "#{doc}/help.txt"
    bin.install "cadubi"
    doc.install "help.txt"
    man1.install "cadubi.1"
  end

  test do
    output = shell_output("script -q /dev/null #{bin}/cadubi -v | cat")
    assert_match "cadubi (Creative ASCII Drawing Utility By Ian) #{version}\r\nCopyright (c) 2015 Ian Langworth", output # complete match because we are not checking the exit code
  end
end
