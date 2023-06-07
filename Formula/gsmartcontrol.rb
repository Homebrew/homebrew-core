class Gsmartcontrol < Formula
  desc "Graphical user interface for smartctl"
  homepage "https://gsmartcontrol.sourceforge.io"
  url "https://downloads.sourceforge.net/project/gsmartcontrol/1.1.4/gsmartcontrol-1.1.4.tar.bz2"
  sha256 "fc409f2b8a84cc40bb103d6c82401b9d4c0182d5a3b223c93959c7ad66191847"
  license any_of: ["GPL-2.0", "GPL-3.0"]

  bottle do
    sha256 arm64_ventura:  "a9c97ad97e0deeb962afc68892bfb742c20d4f41ef1d13f2e5caa9770fd40d9e"
    sha256 arm64_monterey: "1e638dd71d7ddc505c114a12ee172019e76b5ea5e887d3dd699029da4f575d64"
    sha256 arm64_big_sur:  "8ec9da219ebbd29a27c12d64733f54c978772403eced3eff0e716fcd2a27b142"
    sha256 ventura:        "3e1cfccc7e5ead1137e51930832d1c899cf4dbc8aec4603f2518cd949d84aaff"
    sha256 monterey:       "9d91be56a57124bd9ccaa72fe221c6d84cb9a718b01d48b5619f0671e3aa0a78"
    sha256 big_sur:        "9113d814ff679e418fa8df8805149a8194e7235662093bc8509229ecb739d240"
    sha256 catalina:       "f70423df2f81d5cf77155c4c81925aaa6c70864164c01d34b9d77e0c90ec8133"
    sha256 x86_64_linux:   "c8c73de1f4753da98c34ebb9d57944850d7d9fc1f7b79b8ffd12fedebad049b2"
  end

  depends_on "pkg-config" => :build
  depends_on "gtkmm3"
  depends_on "pcre"
  depends_on "smartmontools"

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{sbin}/gsmartcontrol", "--version"
  end
end
