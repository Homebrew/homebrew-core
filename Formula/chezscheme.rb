class Chezscheme < Formula
  desc "Implementation of the Chez Scheme language"
  homepage "https://cisco.github.io/ChezScheme/"
  url "https://github.com/cisco/ChezScheme/archive/v9.5.4.tar.gz"
  sha256 "258a4b5284bb13ac6e8b56acf89a7ab9e8726a90cc57ea1cd71c5da442323840"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256                               big_sur:      "8eae7ff25a1c3b5a7d4192048f53f51904b997eda6c4c7a558e19a0cd461babe"
    sha256                               catalina:     "54d8553a07253c0215f8654f1c54e9ac03734160544ac9823896601e86dd2c81"
    sha256                               mojave:       "a1f551093249b315e309f75e4174995b2d7f475376dc97c78f43e5302ec4b3a6"
    sha256                               high_sierra:  "cb114681db205f5b31da0c3b7906dba46633275b369f6bc3adef4e0411880982"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "bf56d05405a7f9259111292ef50ee73229be14f28fca347d725da5fcfba5af17"
  end

  depends_on "libx11" => :build
  depends_on "xterm"
  uses_from_macos "ncurses"

  def install
    inreplace "configure", "/opt/X11", Formula["libx11"].opt_prefix
    inreplace Dir["c/Mf-*osx"], "/opt/X11", Formula["libx11"].opt_prefix
    inreplace "c/version.h", "/usr/X11R6", Formula["libx11"].opt_prefix
    inreplace "c/expeditor.c", "/usr/X11/bin/resize", Formula["xterm"].opt_bin/"resize"

    system "./configure",
              "--installprefix=#{prefix}",
              "--threads",
              "--installschemename=chez"
    system "make", "install"
  end

  test do
    (testpath/"hello.ss").write <<~EOS
      (display "Hello, World!") (newline)
    EOS

    expected = <<~EOS
      Hello, World!
    EOS

    assert_equal expected, shell_output("#{bin}/chez --script hello.ss")
  end
end
