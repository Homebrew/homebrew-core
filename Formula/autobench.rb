class Autobench < Formula
  desc "Automatic webserver benchmark tool"
  homepage "http://www.xenoclast.org/autobench/"
  url "http://www.xenoclast.org/autobench/downloads/autobench-2.1.2.tar.gz"
  sha256 "d8b4d30aaaf652df37dff18ee819d8f42751bc40272d288ee2a5d847eaf0423b"
  license "GPL-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?autobench[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "feb1d05812e4ccfb525567d4193b0a567498c7aefe1bdf7b9c632b3100ea3e75"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c475644370c0f887d23d5fb77b4c3e24fc31ab21366e35395a8c1214c3f91143"
    sha256 cellar: :any_skip_relocation, monterey:       "2cd26e697396773123b3d800a9a19e10f225b58797849a7ecbe1250969baf77c"
    sha256 cellar: :any_skip_relocation, big_sur:        "dde390cbcb35b87f2cf565a59e11ae4997400a37170abd9b276696460f81dbc4"
    sha256 cellar: :any_skip_relocation, catalina:       "02476e73b18bf8ed02b18fa66b1c90133e21ad28223f528532a427060860dbe9"
    sha256 cellar: :any_skip_relocation, mojave:         "7306e126fae18f469488e3c3952ff8bd67af967510ffd6a021914a59556e0419"
    sha256 cellar: :any_skip_relocation, high_sierra:    "02e3a2a6aa7c3e2d6d0a4500445c7b08bd0804dac28d863944dfd48d41f025d9"
    sha256 cellar: :any_skip_relocation, sierra:         "daecaaf9c3a733c7667c5414371ba948896b0c0eb47dfd1b1ce876921c829390"
    sha256 cellar: :any_skip_relocation, el_capitan:     "37bb6f40825953f9ba176522bc64d74a6375304d7963331aee937417e339964f"
    sha256 cellar: :any_skip_relocation, yosemite:       "9884556bd5f7ab7c29a0aa199328cbe609e04437b1ddce4703214ba65f15d40a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f33306a0edae89cab46f98344c30feeab7a3d9d03e1d6c21e578720c8cac794f"
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
