class Autobench < Formula
  desc "Automatic webserver benchmark tool"
  homepage "http://www.xenoclast.org/autobench/"
  url "http://www.xenoclast.org/autobench/downloads/autobench-2.1.2.tar.gz"
  sha256 "d8b4d30aaaf652df37dff18ee819d8f42751bc40272d288ee2a5d847eaf0423b"
  license "GPL-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "dde390cbcb35b87f2cf565a59e11ae4997400a37170abd9b276696460f81dbc4" => :big_sur
    sha256 "c475644370c0f887d23d5fb77b4c3e24fc31ab21366e35395a8c1214c3f91143" => :arm64_big_sur
    sha256 "02476e73b18bf8ed02b18fa66b1c90133e21ad28223f528532a427060860dbe9" => :catalina
    sha256 "7306e126fae18f469488e3c3952ff8bd67af967510ffd6a021914a59556e0419" => :mojave
    sha256 "02e3a2a6aa7c3e2d6d0a4500445c7b08bd0804dac28d863944dfd48d41f025d9" => :high_sierra
    sha256 "daecaaf9c3a733c7667c5414371ba948896b0c0eb47dfd1b1ce876921c829390" => :sierra
    sha256 "37bb6f40825953f9ba176522bc64d74a6375304d7963331aee937417e339964f" => :el_capitan
    sha256 "9884556bd5f7ab7c29a0aa199328cbe609e04437b1ddce4703214ba65f15d40a" => :yosemite
    sha256 "d31d3625f06d036af97b6cc80d62856b9d3eecadb4ed9fe7a0cb9b96f8d9f9a0" => :mavericks
  end

  depends_on "httperf"

  def install
    system "make", "PREFIX=#{prefix}",
                   "MANDIR=#{man1}",
                   "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "install"
  end

  test do
    system "#{bin}/crfile", "-f", "#{testpath}/test", "-s", "42"
    assert_predicate testpath/"test", :exist?
    assert_equal 42, File.size("test")
  end
end
