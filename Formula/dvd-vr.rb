class DvdVr < Formula
  desc "Utility to identify and extract recordings from DVD-VR files"
  homepage "https://www.pixelbeat.org/programs/dvd-vr/"
  url "https://www.pixelbeat.org/programs/dvd-vr/dvd-vr-0.9.7.tar.gz"
  sha256 "19d085669aa59409e8862571c29e5635b6b6d3badf8a05886a3e0336546c938f"

  bottle do
    cellar :any_skip_relocation
    sha256 "1f815f7699e3bb885c56c3842e9d43ef58d3b338a1405f2f33b26a1b975a1061" => :mojave
    sha256 "e96bdfc31d58a3d94f739937c0efbbdd0b2a60a625aa8c33033e71adf8ee040c" => :high_sierra
    sha256 "7b38c83a9bb9daded6a6f28be018076cdcdbbfb0d47102ecbdd06128bebb33ee" => :sierra
    sha256 "a048c7985df06e3a1d4c7145064b87bd51945f15da2494c03e7af542f07ca8b4" => :el_capitan
    sha256 "22919ace8aeedc16d406797273402498c0c97ceec31e2dfbffcba6fff957ce65" => :yosemite
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "#{bin}/dvd-vr", "--version"
  end
end
