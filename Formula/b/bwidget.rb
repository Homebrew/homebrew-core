class Bwidget < Formula
  desc "Tcl/Tk script-only set of megawidgets to provide the developer additional tools"
  homepage "https://core.tcl-lang.org/bwidget/home"
  url "https://downloads.sourceforge.net/project/tcllib/BWidget/1.10.1/bwidget-1.10.1.tar.gz"
  sha256 "4aea02f38cf92fa4aa44732d4ed98648df839e6537d6f0417c3fe18e1a34f880"
  license "TCL"
  revision 1

  livecheck do
    url "https://sourceforge.net/projects/tcllib/rss?path=/BWidget"
    regex(%r{url=.*?/bwidget[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    manifest_sha256 "0a19ddc1aeb6091f2fe0de093b1bdfd6ccbf604091c5312791b22fe6f567b62f"
    sha256 cellar: :any_skip_relocation, all: "d524a18515be797d08ad291537351a3688c6ec100c38663f4729f50c938204af"
  end

  depends_on "tcl-tk"

  on_linux do
    depends_on "xorg-server" => :test
  end

  deny_network_access!

  def install
    (lib/"bwidget").install Dir["*"]
  end

  test do
    tclsh = formula_opt_bin("tcl-tk")/"tclsh"
    test_bwidget = <<~TCL
      puts [package require BWidget]
      exit
    TCL

    # unable to run in macOS sandbox so only check for error message
    if OS.mac?
      assert_match "cannot use non-numeric floating-point value", pipe_output("#{tclsh} 2>&1", test_bwidget, 0).chomp
      return
    end

    IO.pipe do |read_io, write_io|
      fd = write_io.fileno.to_s
      with_test_process(formula_opt_bin("xorg-server")/"Xvfb", "-displayfd", fd, write_io => write_io) do
        write_io.close
        ENV["DISPLAY"] = ":#{read_io.read.strip}"
        assert_equal version.to_s, pipe_output(tclsh, test_bwidget, 0).chomp
      end
    end
  end
end
