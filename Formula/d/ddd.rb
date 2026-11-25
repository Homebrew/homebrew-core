class Ddd < Formula
  desc "Graphical front-end for command-line debuggers"
  homepage "https://www.gnu.org/software/ddd/"
  url "https://ftpmirror.gnu.org/ddd/ddd-3.5.0.tar.gz"
  mirror "https://ftp.gnu.org/gnu/ddd/ddd-3.5.0.tar.gz"
  sha256 "458aa058f6b287bd7c37439bbb9b6eef068ddaec7046f34e13edbc1752456a4e"
  license all_of: [
    "GPL-3.0-or-later",
    "GFDL-1.1-no-invariants-or-later", # ddd/ddd-themes.info
    "GFDL-1.3-no-invariants-or-later", # ddd/ddd.info
    "HPND-sell-variant", # ddd/motif/LabelH.C
    "MIT-open-group", # ddd/athena_ddd/PannerM.C
  ]

  bottle do
    manifest_sha256 "629f11e2003ea7d101a55801f5b3c998affb73c499cd312bfe78f9dbc4bc98ac"
    sha256 arm64_golden_gate: "b06eafbccc9586af01d8d12d3ddd1368984b531b8d26f8d541a9b5597508dce8"
    sha256 arm64_tahoe:       "82f791380c205f628d48ea365343d1c42838c6aff4ec71bac19dcc8ff5c539ba"
    sha256 arm64_sequoia:     "7d36a035bb3a5a4ee98154ed27443a9843b3d8a45757abfa537516bdf3676248"
    sha256 arm64_linux:       "db91e20e05575528cdc14468848297e9e457d67e49c9b888d67a8f51ecea1775"
    sha256 x86_64_linux:      "c525836c2d6ce20edd2bd84ea240db88950f1b11bf765ed5c9de640d836a5efc"
  end

  depends_on "fontconfig"
  depends_on "libx11"
  depends_on "libxaw"
  depends_on "libxext"
  depends_on "libxft"
  depends_on "libxmu"
  depends_on "libxpm"
  depends_on "libxt"
  depends_on "openmotif"
  depends_on "tinyxml2"

  uses_from_macos "ncurses"

  on_macos do
    depends_on "gnu-sed" => :build
    depends_on "libice"
    depends_on "libsm"
    depends_on "libxp"

    on_intel do
      depends_on "gdb" => :test
    end
  end

  on_linux do
    depends_on "gdb" => :test
  end

  deny_network_access!

  def install
    # Use GNU sed due to ./unumlaut.sed: RE error: illegal byte sequence
    ENV.prepend_path "PATH", formula_opt_libexec("gnu-sed")/"gnubin" if OS.mac?

    # Help configure find freetype headers
    ENV.append_to_cflags "-I#{formula_opt_include("freetype")}/freetype2"

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
      # Avoid `pwd` and loading a program as gdb cannot find its working directory in the Linux sandbox
      assert_match "$1 = 42", pipe_output("#{bin}/ddd --gdb --nw 2>&1", "print 6*7\nquit")
    end
  end
end
