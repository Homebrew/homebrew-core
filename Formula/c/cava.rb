class Cava < Formula
  desc "Console-based Audio Visualizer for ALSA"
  homepage "https://github.com/karlstav/cava"
  url "https://github.com/karlstav/cava/archive/refs/tags/0.10.1.tar.gz"
  sha256 "a3a60814326fa34b54e93ce0b1e66460d55f1007e576c5152fd47024d9ceaff9"
  license "MIT"
  head "https://github.com/karlstav/cava.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "f74b0fcad6a503613d9e8fa7e39864fcbd5b29edc7573e490bd804a193df558a"
    sha256 cellar: :any, arm64_ventura:  "b9572317b554c1a29c4fbe8b9631f4202d54ef246489f3b97dada007c1db07dc"
    sha256 cellar: :any, arm64_monterey: "033d4e6bd3af308e2eb2f676781098cd68a73b8bd3cfe16ac18cac02f99942c8"
    sha256 cellar: :any, sonoma:         "3eddff336e77820a53ef1d4073b0a286a4cce40afa6aa19fa1a3e120d2767cb8"
    sha256 cellar: :any, ventura:        "470ac5040c44a1148926ce37717f054a478882d6b80dafdc16cee0432c65402d"
    sha256 cellar: :any, monterey:       "8e05dc874b5893de5995ab17654011e5d29b464d1610f64e64fa236a9571ce5c"
    sha256               x86_64_linux:   "983610bdfc5e0df084528e43480c3dc5f23bb77e4fb8b8ab0f7b5984a1a99a95"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool"  => :build
  depends_on "pkg-config"  => :build
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
