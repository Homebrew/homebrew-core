class Cava < Formula
  desc "Console-based Audio Visualizer for ALSA"
  homepage "https://github.com/karlstav/cava"
  url "https://github.com/karlstav/cava/archive/0.8.3.tar.gz"
  sha256 "ce7378ababada5a20fa8250c6b3fe6412bc1a7dd31301a52b8b4a71d362875b9"
  license "MIT"
  head "https://github.com/karlstav/cava.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "d9dfab68c25b0611aefcc14a14536f854a0794d4ca8f11208dfed9ab6c26f570"
    sha256 cellar: :any, arm64_monterey: "2f5e951e4c9c6fbd64ddd4403c33b48c7367e03c8f0d8f1acb4cb27fc7b72dfd"
    sha256 cellar: :any, arm64_big_sur:  "458780bb7131958baa5b9abe176cb52c3082a403fb5bbc91fffdae6570b8c9d1"
    sha256 cellar: :any, ventura:        "f67fbbd62edc1b8e6ed8a2d24c0d43bf0a9e7f6e2a57d94df495abb9bde36645"
    sha256 cellar: :any, monterey:       "c19ebbd4247a0a705ff515fbd69da8606b5803cfca8e9e1b55424f6cbbb444e5"
    sha256 cellar: :any, big_sur:        "ac96c19d44f043541d965ab4b44196c598c64b404dbbc9463bd40489b6859c94"
    sha256 cellar: :any, catalina:       "195e10dc98dc6070ef4a876618b66f73217cd85da70089e5d9202ff7dd996991"
    sha256               x86_64_linux:   "7281c3eb4ae6ec6535148729c725978c88bc45655b357e4b9d983b24f8556e0d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool"  => :build
  depends_on "fftw"
  depends_on "iniparser"
  depends_on "portaudio"

  uses_from_macos "vim" => :build # needed for xxd
  uses_from_macos "ncurses"

  def install
    # change ncursesw to ncurses
    inreplace "configure.ac", "ncursesw", "ncurses"
    # force autogen.sh to look for and use our glibtoolize
    inreplace "autogen.sh", "libtoolize", "glibtoolize"

    system "./autogen.sh"
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"
  end

  test do
    cava_config = (testpath/"cava.conf")
    cava_stdout = (testpath/"cava_stdout.log")

    cava_config.write <<~EOS
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
