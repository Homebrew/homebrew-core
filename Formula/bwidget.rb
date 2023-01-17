class Bwidget < Formula
  desc "Tcl/Tk script-only set of megawidgets to provide the developer additional tools"
  homepage "https://core.tcl-lang.org/bwidget/home"
  url "https://downloads.sourceforge.net/project/tcllib/BWidget/1.9.16/bwidget-1.9.16.tar.gz"
  sha256 "bfe0036374b84293d23620a7f6dda86571813d0c7adfed983c1f337e5ce81ae0"
  license "TCL"

  depends_on "tcl-tk"

  def install
    (lib/"bwidget").install Dir["*"]
  end

  test do
    # Fails with: no display name and no $DISPLAY environment variable
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    # Fails on macOS 11 if CI minimum OS version is too low (1106 vs 1107)
    return if OS.mac? && MacOS.version < :monterey

    test_bwidget = <<~EOS
      catch {
        package require BWidget
        puts "OK"
      }
      exit
    EOS
    assert_equal "OK\n", pipe_output("tclsh", test_bwidget), "Bwidget test failed"
  end
end
