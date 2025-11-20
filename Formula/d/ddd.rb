class Ddd < Formula
  desc "Graphical front-end for command-line debuggers"
  homepage "https://www.gnu.org/software/ddd/"
  url "https://ftpmirror.gnu.org/gnu/ddd/ddd-3.4.1.tar.gz"
  mirror "https://ftp.gnu.org/gnu/ddd/ddd-3.4.1.tar.gz"
  sha256 "b87517a6c3f9611566347e283a2cf931fa369919b553536a2235e63402f4ee89"
  license all_of: [
    "GPL-3.0-or-later",
    "GFDL-1.1-no-invariants-or-later", # ddd/ddd-themes.info
    "GFDL-1.3-no-invariants-or-later", # ddd/ddd.info
    "HPND-sell-variant", # ddd/motif/LabelH.C
    "MIT-open-group", # ddd/athena_ddd/PannerM.C
  ]

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "25083bd2eeac8896b1406a713d5ca294cacb800fee16e0368e434e6715b72644"
    sha256 arm64_sequoia:  "3c31137211b8185a0b8e3ceffce6474c803cf8790348211ad0690162697a1613"
    sha256 arm64_sonoma:   "73e84236c870313e5a43e936998545961609c5f43104e6b57cd693a03dc52a5d"
    sha256 arm64_ventura:  "d287abe1d656058174b03b2e1215e7eee7d996fad1e041fd8d14e573b3e0716f"
    sha256 arm64_monterey: "e2f58c650c498dd2ab90369baee0dad09b169e503e8616894f6814ba543310a8"
    sha256 sonoma:         "19e15c98f1732a8c5032734ecdab5f4aec373ef3991bc65c7ce4e5f81b526861"
    sha256 ventura:        "47ff49d7888461a987aee0ae62749dc96d6c44c6825f09a61d637f13cd736198"
    sha256 monterey:       "33047c998d6856a9425df4fa92fd9f3fdfe7717921def4bb814ae82ceb928927"
    sha256 arm64_linux:    "dc505cec52e34353405b1d359a97aa65f7b06a89cbba7be62ce119bd17c6d24d"
    sha256 x86_64_linux:   "52266be4e6e825db9c2941e2ab44002d1d3707b379e0339d3ddf12af18f81ad6"
  end

  depends_on "fontconfig"
  depends_on "libx11"
  depends_on "libxaw"
  depends_on "libxft"
  depends_on "libxmu"
  depends_on "libxpm"
  depends_on "libxt"
  depends_on "openmotif"

  uses_from_macos "ncurses"

  on_macos do
    depends_on "gnu-sed" => :build
    depends_on "libice"
    depends_on "libsm"
    depends_on "libxext"
    depends_on "libxp"

    on_intel do
      depends_on "gdb" => :test
    end
  end

  on_linux do
    depends_on "gdb" => :test
  end

  def install
    # Use GNU sed due to ./unumlaut.sed: RE error: illegal byte sequence
    ENV.prepend_path "PATH", Formula["gnu-sed"].libexec/"gnubin" if OS.mac?

    # Help configure find freetype headers
    ENV.append_to_cflags "-I#{Formula["freetype"].opt_include}/freetype2"

    system "./configure", "--disable-silent-rules",
                          "--enable-builtin-app-defaults",
                          "--enable-builtin-manual",
                          *std_configure_args

    # From MacPorts: make will build the executable "ddd" and the X resource
    # file "Ddd" in the same directory, as HFS+ is case-insensitive by default
    # this will loosely FAIL
    system "make", "EXEEXT=exe"

    ENV.deparallelize
    system "make", "install", "EXEEXT=exe"
    mv bin/"dddexe", bin/"ddd"
  end

  test do
    output = shell_output("#{bin}/ddd --version")
    output.force_encoding("ASCII-8BIT") if output.respond_to?(:force_encoding)
    assert_match version.to_s, output

    if OS.mac? && Hardware::CPU.arm?
      # gdb is not supported on macOS ARM. Other debuggers like --perl need window
      # and using --nw causes them to just pass through to normal execution.
      # Since it is tricky to test window/XQuartz on CI, just check no crash.
      assert_equal "Test", shell_output("#{bin}/ddd --perl --nw -e \"print 'Test'\"")
    else
      assert_match testpath.to_s, pipe_output("#{bin}/ddd --gdb --nw true 2>&1", "pwd\nquit")
    end
  end
end
