class Cava < Formula
  desc "Console-based Audio Visualizer for ALSA"
  homepage "https://github.com/karlstav/cava"
  url "https://github.com/karlstav/cava/archive/0.8.1.tar.gz"
  sha256 "b93f9dc1285142c8488dce93f77a5a31b52a7a6ac7a052d9bbe3c78e3507a4e8"
  license "MIT"
  head "https://github.com/karlstav/cava.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "b9a0428949158a1c41d65288431f680c7852fff122a8e989877489a7758ee85b"
    sha256 cellar: :any, arm64_big_sur:  "90037b3a25613aba832f187a1c744eee7c88cc778cb152d2294cc3dbb4ae292d"
    sha256 cellar: :any, monterey:       "72a65af7592fc0a51c90f9c8bbb49a0434d7a7f45ec0ffb5b09b9751850085d5"
    sha256 cellar: :any, big_sur:        "93fd5c02f56cce078610dcac879905fa85a86a245e2329d287215fca3bf33f20"
    sha256 cellar: :any, catalina:       "0724c4e35cff72b75142831b06c191d95c3e134c5c8de3faee1ecda419b6c894"
    sha256               x86_64_linux:   "4f8e76b8b7203526f9ed11858483059703f3d991121c03216cb39040c94da2f3"
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
