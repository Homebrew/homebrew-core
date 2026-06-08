class Libklvanc < Formula
  desc "VANC Processing Framework"
  homepage "https://github.com/stoth68000/libklvanc"
  url "https://github.com/stoth68000/libklvanc/archive/refs/tags/vid.obe.1.6.0.tar.gz"
  sha256 "5076ca48455a4ef4ead2cd880ba189b21937a9ad8fd458adfc133d7bb1c948c3"
  license "LGPL-2.1-only"
  head "https://github.com/stoth68000/libklvanc.git", branch: "master"

  livecheck do
    url :stable
    strategy :git
    regex(/^vid\.obe\.(\d+(?:\.\d+)+)$/i)
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./autogen.sh", "--build"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"

    # Create pkgconfig based on 1.6.x versions.
    # https://github.com/stoth68000/libklvanc/blob/master/src/libklvanc.pc.in
    # TODO: Remove next release.
    unless build.head?
      (lib/"pkgconfig/libklvanc.pc").write <<~EOS
        prefix=#{prefix}
        exec_prefix=${prefix}
        libdir=${exec_prefix}/lib
        includedir=${prefix}/include

        Name: libklvanc
        Description: Kernel Labs Library for processing Vertical Ancillary Data (VANC)
        Version: #{version}
        Libs: -L${libdir} -lklvanc
        Libs.private:  -lpthread -lstdc++ -lm -lc
        Cflags: -I${includedir} -I${includedir}/libklvanc
        URL: https://github.com/stoth68000/libklvanc.git
      EOS
    end
  end

  test do
    output = shell_output("#{bin}/klvanc_afd").match(%r{PASS:\s+(\d+)/(\d+),\s+Failures:\s+(\d+)})
    assert output
    assert_equal [output[2], "0"], [output[1], output[3]]
  end
end
