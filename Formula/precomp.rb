class Precomp < Formula
  desc "Command-line precompressor to achieve better compression"
  homepage "http://schnaader.info/precomp.php"
  url "https://github.com/schnaader/precomp-cpp/archive/v0.4.6.tar.gz"
  sha256 "673b9ceb0df62abb5ef12ab0600a18fc3b82003cc9af5e1cc2f196237ed350d3"
  head "https://github.com/schnaader/precomp-cpp.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3984c5a8010fe9f82d3b8fdc757211def7af9675be330ba7883b867ca5d29c55" => :high_sierra
    sha256 "d1d6345d53fe8a80389d3fcbb3aa3fcb3abf62ec16eca16023fc42bf3b9452aa" => :sierra
    sha256 "327439d7580922ac4bbbdc521787a21327ec71e34b15bcbd8482322f3c196c55" => :el_capitan
  end

  def install
    # Seems like Yosemite does not like the -s flag
    inreplace "Makefile", " -s ", " "

    system "make"
    bin.install "precomp"
  end

  test do
    cp "#{bin}/precomp", testpath/"precomp"
    system "gzip", "-1", testpath/"precomp"

    system "#{bin}/precomp", testpath/"precomp.gz"
    rm testpath/"precomp.gz", :force => true
    system "#{bin}/precomp", "-r", testpath/"precomp.pcf"
    system "gzip", "-d", testpath/"precomp.gz"
  end
end
