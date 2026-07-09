class Cava < Formula
  desc "Console-based Audio Visualizer for ALSA"
  homepage "https://github.com/karlstav/cava"
  url "https://github.com/karlstav/cava/archive/refs/tags/1.0.0.tar.gz"
  sha256 "2866cea11d0bd38406924ab2b47d5577f14909a7321ee928b6836391f375af7e"
  license "MIT"
  head "https://github.com/karlstav/cava.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "209fa9f1436d056a4b2d73f2adbc35557f267e3d9fd7f0ed939b09cf97a524da"
    sha256 cellar: :any, arm64_sequoia: "812fa702df7f0c09a1806d71d61f31c8303f29af5ce75de86cd70a18ccd3c25d"
    sha256 cellar: :any, arm64_sonoma:  "fcd2bd495dd947c25c56470a70e2a1ee89cdebe4a72f5eceaf26acf4f3a9e5d5"
    sha256 cellar: :any, sonoma:        "76b24034b455cf6b01180186f0446bcf96b4aba471c01b2848dd2f6c8c44fd27"
    sha256               arm64_linux:   "74a4472bdf1c72e81ab0104df9b70f0d7506c1072fc6a2b4c302284652683cdc"
    sha256               x86_64_linux:  "c5f1dac189a1c98e6a87173b612d9509eaf5d947351c7f8cb3e06ee02f6a64f6"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool"  => :build
  depends_on "pkgconf"  => :build

  depends_on "fftw"
  depends_on "iniparser"

  uses_from_macos "vim" => :build # needed for xxd
  uses_from_macos "ncurses"

  on_macos do
    depends_on "portaudio"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "pipewire"
    depends_on "pulseaudio"
  end

  def install
    # change ncursesw to ncurses
    inreplace "configure.ac", "ncursesw", "ncurses"
    # force autogen.sh to look for and use our glibtoolize
    inreplace "autogen.sh", "libtoolize", "glibtoolize"

    ENV.append "CPPFLAGS", "-I#{formula_opt_include("iniparser")}/iniparser"
    ENV.append "LDFLAGS", "-L#{formula_opt_lib("iniparser")}"

    system "./autogen.sh"
    system "./configure", "--disable-silent-rules", *std_configure_args
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

    sleep 5

    assert_match "0;0;\n", cava_stdout.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
