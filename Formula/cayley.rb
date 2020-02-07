class Cayley < Formula
  desc "An open-source graph database"
  homepage "https://cayley.io/"
  url "https://github.com/cayleygraph/cayley/releases/download/v0.7.7/cayley_0.7.7_darwin_amd64.tar.gz"
  version "0.7.7"
  sha256 "37ef9043cb20aeffa93d57f360fdee3e0c9d1b2fa8d404a00f3bff1b58937206"

  bottle :unneeded

  def install
    bin.install "cayley"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cayley version")
  end
end
