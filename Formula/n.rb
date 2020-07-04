class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/v6.6.0.tar.gz"
  sha256 "c082e234e89928f5facd33dfa57ecb1de88b246429a8e88a3e14b7d69ce52964"
  head "https://github.com/tj/n.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cc203ce1afe1d3bf97a5c01420e506cfea9e3e57fa3511c7ad3edd4c072d4612" => :catalina
    sha256 "cc203ce1afe1d3bf97a5c01420e506cfea9e3e57fa3511c7ad3edd4c072d4612" => :mojave
    sha256 "cc203ce1afe1d3bf97a5c01420e506cfea9e3e57fa3511c7ad3edd4c072d4612" => :high_sierra
  end

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
