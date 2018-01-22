class Genact < Formula
  desc "Nonsense activity generator"
  homepage "https://svenstaro.github.io/genact/"
  url "https://github.com/svenstaro/genact/releases/download/0.3.2/genact-osx"
  version "0.3.2"
  sha256 "da1b9d4c1d2d529f62a5d25f4a6e7b9cbf907eec8c81f84575f1fd834f65a844"

  bottle :unneeded

  def install
    bin.install "genact-osx"
  end
  test do
    assert_match "genact #{version}", shell_output("#{bin}/ncdu -v")
  end
end
