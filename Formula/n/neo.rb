class Neo < Formula
  desc "Simulates the digital rain from \"The Matrix\""
  homepage "https://github.com/st3w/neo"
  url "https://github.com/st3w/neo/releases/download/v0.6.1/neo-0.6.1.tar.gz"
  sha256 "a55e4ed5efd0a4af248d16018a7aaad3b617ef1d3ac05d292a258a38aaf46a79"
  license "GPL-3.0-or-later"

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  uses_from_macos "ncurses"

  def install
    if OS.mac?
      ncurses_include = MacOS.sdk_path_if_needed ? "#{MacOS.sdk_path_if_needed}/usr/include" : "/usr/include"
      ncurses_lib = MacOS.sdk_path_if_needed ? "#{MacOS.sdk_path_if_needed}/usr/lib" : "/usr/lib"
      ENV.append "LDFLAGS", "-L#{ncurses_lib}"
      ENV.append "CPPFLAGS", "-I#{ncurses_include}"
    else
      ncurses = Formula["ncurses"]
      ENV.append "LDFLAGS", "-L#{ncurses.opt_lib}"
      ENV.append "CPPFLAGS", "-I#{ncurses.opt_include}"
    end

    inreplace "configure.ac", "ncursesw", "ncurses"
    system "autoreconf", "-fvi"
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/neo -V")
  end
end
