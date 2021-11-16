class Goodhosts < Formula
  desc "Simple hosts file management in a Go cli"
  homepage "https://github.com/goodhosts/cli"
  url "https://github.com/goodhosts/cli/releases/download/v1.0.7/goodhosts_darwin_amd64.tar.gz"
  sha256 "af89d518a2a23ed48dc2d8fef72fe594e131df90487726a765f730f0260a532c"
  license "MIT"

  def install
    bin.install "goodhosts"
  end

  test do
    system "goodhosts", "--help"
  end
end
