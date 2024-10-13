class Bwidget < Formula
  desc "Tcl/Tk script-only set of megawidgets to provide the developer additional tools"
  homepage "https://core.tcl-lang.org/bwidget/home"
  url "https://downloads.sourceforge.net/project/tcllib/BWidget/1.9.16/bwidget-1.9.16.tar.gz"
  sha256 "bfe0036374b84293d23620a7f6dda86571813d0c7adfed983c1f337e5ce81ae0"
  license "TCL"

  livecheck do
    url "https://sourceforge.net/projects/tcllib/rss?path=/BWidget"
    regex(%r{url=.*?/bwidget[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "2387ff5ce82cacdd42cd8f172b38abde95b856256861c572a9ff1e14eda03415"
  end

  depends_on "tcl-tk"

  def install
    (lib/"bwidget").install Dir["*"]
  end

  test do
    # Fails with: no display name and no $DISPLAY environment variable
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    test_bwidget = <<~EOS
      puts [package require BWidget]
      exit
    EOS
    assert_equal version.to_s, pipe_output("#{Formula["tcl-tk"].bin}/tclsh", test_bwidget).chomp
  end
end
