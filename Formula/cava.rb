class Cava < Formula
  desc "Console-based Audio Visualizer for ALSA"
  homepage "https://github.com/karlstav/cava"
  url "https://github.com/karlstav/cava/archive/0.8.2.tar.gz"
  sha256 "99bc302ce77f8093a4ac1cf94be51581e37c075428117f248ffe1fee650f47d8"
  license "MIT"
  head "https://github.com/karlstav/cava.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "89c862723b2716b7679e5efc78e716b09d1f45fd2c2a1edbd51a9c65b80d4343"
    sha256 cellar: :any, arm64_big_sur:  "ac197a673c179b5cc6b908238b390d0895c0c6687310ce242ff906bb833085b7"
    sha256 cellar: :any, monterey:       "fc8442ab578524fae2beb5b1ee7a27b685201d9cef2156193bd92734300a4948"
    sha256 cellar: :any, big_sur:        "abc65c805ead74fb13a651f664a692afa4cc208670570123d6fdeb359d8a64f8"
    sha256 cellar: :any, catalina:       "d96daa890f9abd0fe8d8cd56feb7d9462cc57fe8fbbf59967c88074ffd062fa8"
    sha256               x86_64_linux:   "2f8f05f61182fd20761e06eb7255f03f34466b7ecd992e72a12bf555e0f5c280"
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
