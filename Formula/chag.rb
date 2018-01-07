class Chag < Formula
  desc "Use your changelog as the canonical source of change data"
  homepage "https://github.com/mtdowling/chag"
  url "https://github.com/mtdowling/chag/archive/1.1.3.tar.gz"
  sha256 "f507476800c7521ca0e5c26ad699e33a581b800cfc93de03f468092a6381cb52"

  def install
    bin.install "chag"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chag --version")
  end
end
