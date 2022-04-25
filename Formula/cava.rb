class Cava < Formula
  desc "Console-based Audio Visualizer for ALSA"
  homepage "https://github.com/karlstav/cava"
  url "https://github.com/karlstav/cava/archive/0.8.2.tar.gz"
  sha256 "99bc302ce77f8093a4ac1cf94be51581e37c075428117f248ffe1fee650f47d8"
  license "MIT"
  head "https://github.com/karlstav/cava.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "1c8ec9731e4e56550cf312b6041179cb16316b4818a52b3dd558597133b0bb53"
    sha256 cellar: :any, arm64_big_sur:  "226b93ad253eed2465a398bd6381c71999320e105676e7961be3a10f34069f72"
    sha256 cellar: :any, monterey:       "4e1690de73dbea81bc6697e6a1d050fdebf91274d7a7fd996333f8e82aa90dcf"
    sha256 cellar: :any, big_sur:        "971a0e52a5361c4bcb8f7f2f97defa235bb7e5340630250068c4696dd9788184"
    sha256 cellar: :any, catalina:       "3fd9eca9470a8a0ef1f91f93b7a5233fbb2c21c2936ec509334e6718c6836ebb"
    sha256               x86_64_linux:   "67e728fbfd88559d18e5e43293d5864bbcf0b65872c2d1b62d73b9f5cbb861d2"
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
