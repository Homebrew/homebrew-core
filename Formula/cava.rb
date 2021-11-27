class Cava < Formula
  desc "Console-based Audio Visualizer for ALSA"
  homepage "https://github.com/karlstav/cava"
  url "https://github.com/karlstav/cava/archive/0.7.4.tar.gz"
  sha256 "fefd3cc04d41b03ca416630cafadbfda6c75e2ca0869da1f03963dcb13e1ecb7"
  license "MIT"
  head "https://github.com/karlstav/cava.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "a9bcaeba0b6e4a72d01e93909b89f5492c629447e059e19bc076315185e7be10"
    sha256 cellar: :any, arm64_big_sur:  "eba8aee3d32a5903073a503200b4e4a28d3ea531263085e16ff4591a7b93454e"
    sha256 cellar: :any, monterey:       "0ea0d7a31c270df64bc423de9623e8e3a32bea2f09ac4e700dc3c204b0b5ed7f"
    sha256 cellar: :any, big_sur:        "8cfbe0a65351827ec14c810390951c577f48ab9cc21a05b84929d9dc9d4056d6"
    sha256 cellar: :any, catalina:       "83320de97b0893a387b0e44778e55698ae5e2a6a167947de5b8d7cc6c21765e4"
    sha256               x86_64_linux:   "9a61fb2396cad4d2a4132bb2027f9aee52d1daff2949187a6ece75c86452e058"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool"  => :build
  depends_on "fftw"
  depends_on "iniparser"
  depends_on "portaudio"

  uses_from_macos "ncurses"

  def install
    # change ncursesw to ncurses
    inreplace "configure.ac", "ncursesw", "ncurses"
    # force autogen.sh to look for and use our glibtoolize
    inreplace "autogen.sh", "libtoolize", "glibtoolize"

    # to be remove with versions greater 0.7.4:
    # correct Makefile.am with hardcoded libpath
    inreplace "Makefile.am", "/usr/local", HOMEBREW_PREFIX unless build.head?

    system "./autogen.sh"
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"
  end

  test do
    cava_config = (testpath/"cava.conf")
    cava_stdout = (testpath/"cava_stdout.log")

    (cava_config).write <<~EOS
      [general]
      bars = 2
      sleep_timer = 1

      [input]
      method = fifo
      source = /dev/zero

      [output]
      method = raw
      data_format = ascii
    EOS

    pid = spawn(bin/"cava", "-p", cava_config, [:out, :err] => cava_stdout.to_s)
    sleep 2
    Process.kill "KILL", pid
    assert_match "0;0;\n", cava_stdout.read
  end
end
