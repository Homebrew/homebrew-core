class Fnm < Formula
  desc "Fast and simple Node.js version manager"
  homepage "https://github.com/Schniz/fnm"
  url "https://github.com/Schniz/fnm/releases/download/v1.2.0/fnm-macos.zip"
  version "1.2.0"
  sha256 "e12ec42b5cc9dfbcd0fd9cfb3e4a0e0e125f6bb486ec1f67ac8b03585456a124"

  bottle :unneeded

  def install
    bin.install "fnm"
  end

  def caveats; <<~EOS
    Add the following line to your #{shell_profile} file:
      eval `fnm env`

    If you are using fish shell, add this line to your config.fish file:
      eval (fnm env --fish)
  EOS
  end

  test do
    system "#{bin}/fnm", "--version"
  end
end
