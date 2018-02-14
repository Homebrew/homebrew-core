class Gimme < Formula
  desc "Shell script to install any Go version"
  homepage "https://github.com/travis-ci/gimme"
  url "https://github.com/travis-ci/gimme/archive/v1.3.0.tar.gz"
  sha256 "0facfa300107b66f0cd253d62f55e55e91f4249a4a9d82d4fdcf1b2216a57b65"

  bottle :unneeded

  def install
    bin.install "gimme"
  end

  test do
    system "#{bin}/gimme", "-l"
  end
end
