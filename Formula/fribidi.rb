class Fribidi < Formula
  desc "Implementation of the Unicode BiDi algorithm"
  homepage "https://github.com/fribidi/fribidi"
  url "https://github.com/fribidi/fribidi/releases/download/v1.0.5/fribidi-1.0.5.tar.bz2"
  sha256 "6a64f2a687f5c4f203a46fa659f43dd43d1f8b845df8d723107e8a7e6158e4ce"

  bottle do
    cellar :any
    sha256 "bd64b60177d5d9fcb80a65082d2a185b9ab16fa94375c8ce231822fc182ae4b0" => :catalina
    sha256 "56d5510ea4bc68244be0fd9c4aea28fb237102d436dc53588f82e4f4ed0bb357" => :mojave
    sha256 "840d79617e028fbf2a65f504a1510a86df4339bbfceaff276038a497e37700d4" => :high_sierra
    sha256 "3535f072625cf8135abefc6a64e677e31efcc84dfd3340e5e344e3775abd3ccf" => :sierra
    sha256 "48213fcb9b2f2e126854062a3f21659de1021f22e5c924200ca751f9273332b9" => :el_capitan
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-static"
    system "make", "install"
  end

  test do
    (testpath/"test.input").write <<~EOS
      a _lsimple _RteST_o th_oat
    EOS

    assert_match /a simple TSet that/, shell_output("#{bin}/fribidi --charset=CapRTL --test test.input")
  end
end
