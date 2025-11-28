class Gtkwave < Formula
  desc "GTK-based wave viewer for viewing VCD, GHW, FST, and other waveform files"
  homepage "https://gtkwave.github.io/gtkwave/"
  url "https://github.com/gtkwave/gtkwave/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "d5558cd419c8d46bdc958064cb97f963d1ea793866414c025906ec15033512ed"
  license "GPL-2.0-or-later"
  head "https://github.com/gtkwave/gtkwave.git", branch: "master"

  depends_on "flex" => :build
  depends_on "gperf" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "glib"
  # GTKWave requires both GTK3 and GTK4 - the upstream meson.build unconditionally
  # requires both: gtk+-3.0 for the main application and gtk4 for libgtkwave library.
  # See: https://github.com/gtkwave/gtkwave/blob/v3.4.0/meson.build
  depends_on "gtk+3"
  depends_on "gtk4"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gtk-mac-integration"
  end

  def install
    system "meson", "setup", "build", *std_meson_args, "-Dupdate_mime_database=false"
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    # Create a minimal VCD file
    (testpath/"test.vcd").write <<~VCD
      $timescale 1ns $end
      $var wire 1 ! clk $end
      $enddefinitions $end
      #0
      0!
      #10
      1!
      #20
      0!
    VCD

    # Convert VCD to FST format and verify the output file exists
    system bin/"vcd2fst", "test.vcd", "test.fst"
    assert_path_exists testpath/"test.fst"

    # Verify version output
    assert_match version.to_s, shell_output("#{bin}/gtkwave --version")
  end
end
