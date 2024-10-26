class Gtkwave < Formula
  desc "GTK+ based waveform viewer"
  homepage "https://gtkwave.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/gtkwave/gtkwave-gtk3-3.3.121/gtkwave-gtk3-3.3.121.tar.gz"
  sha256 "54aa45788d6d52afb659c3aef335aafde0ef2c8990a7770f8eaa64e57f227346"
  license "GPL-2.0-or-later"

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "at-spi2-core"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "harfbuzz"
  depends_on "pango"
  depends_on "tcl-tk"
  depends_on "xz"

  uses_from_macos "gperf" => :build
  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gtk-mac-integration"

    # This patch removes the need of GtkSocket and GtkPlug on macOS because
    # they are not available on macOS.
    # It also fixes a problem that causes gtk-mac-integration not used.
    #
    # Once the upstream accepted this pull request, this patch can be removed.
    # https://github.com/gtkwave/gtkwave/pull/389
    patch :p2 do
      url "https://github.com/yanjiew1/gtkwave/compare/0704899d...f3a85609.patch"
      sha256 "4d4c730777cb4f0a243387b8793e0230ea68d3ac8368c61118bbb984c096117a"
    end
  end

  on_linux do
    depends_on "xorg-server" => :test
  end

  def install
    system "./configure", "--enable-gtk3",
                          "--with-tcl=#{Formula["tcl-tk"].opt_prefix}/lib",
                          "--with-tk=#{Formula["tcl-tk"].opt_prefix}/lib",
                          *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.vcd").write <<~EOS
      $timescale 1ns $end
      $scope module logic $end
      $var wire 3 # x $end
      $var wire 1 $ y $end
      $upscope $end
      $enddefinitions $end
      $dumpvars
      b000 #
      1$
      $end
      #0
      b001 #
      0$
      #250
      b110 #
      1$
      #500
    EOS

    output = if OS.linux?
      shell_output("xvfb-run --auto-servernum -- #{bin}/gtkwave -x test.vcd 2>&1")
    else
      shell_output("#{bin}/gtkwave -x test.vcd 2>&1")
    end

    expected = <<~EOS
      [0] start time.
      [500] end time.
      Exiting early because of --exit request.
    EOS

    assert_includes output, "GTKWave Analyzer v#{version}"
    assert_includes output, expected
  end
end
