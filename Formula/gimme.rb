class Gimme < Formula
  desc "Shell script to install any Go version"
  homepage "https://github.com/travis-ci/gimme"
  url "https://github.com/travis-ci/gimme/archive/v1.4.0.tar.gz"
  sha256 "e972303f3287964e3c1626b1c966a69e671de0cd78d82ce0caecd2230ffb090e"

  bottle :unneeded

  def install
    bin.install "gimme"
  end

  test do
    system "#{bin}/gimme", "-l"
  end
end
