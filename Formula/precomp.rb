class Precomp < Formula
  desc "Command-line precompressor to achieve better compression"
  homepage "http://schnaader.info/precomp.php"
  url "https://github.com/schnaader/precomp-cpp/archive/v0.4.5.tar.gz"
  sha256 "39add141554f0186200911ab61838b69f5777956b3dfd37d82bb6923607258dc"
  head "https://github.com/schnaader/precomp-cpp.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3984c5a8010fe9f82d3b8fdc757211def7af9675be330ba7883b867ca5d29c55" => :high_sierra
    sha256 "d1d6345d53fe8a80389d3fcbb3aa3fcb3abf62ec16eca16023fc42bf3b9452aa" => :sierra
    sha256 "327439d7580922ac4bbbdc521787a21327ec71e34b15bcbd8482322f3c196c55" => :el_capitan
  end

  def install
    # HEAD already has that, but current stable version does not compile with clang without that patch
    inreplace "contrib/packmp3/Makefile", "-fsched-spec-load ", ""

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
