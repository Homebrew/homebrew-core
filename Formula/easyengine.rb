class Easyengine < Formula
  desc "Command-line control panel to manage WordPress sites"
  homepage "https://easyengine.io/"
  url "https://github.com/EasyEngine/easyengine/releases/download/v4.0.0/easyengine.phar"
  sha256 "5d7f7ec95911883240717458024f0e7c69309f7bd3646353a0594e1b0900eaa6"

  bottle :unneeded

  depends_on "php"

  def install
    bin.install "easyengine.phar" => "ee"
  end

  def caveats; <<~EOS
    EasyEngine requires Docker to work.

    You can install Docker using:

      brew cask install docker
  EOS
  end

  test do
    system bin/"ee cli version"
  end
end
