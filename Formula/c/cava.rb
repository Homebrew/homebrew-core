class Cava < Formula
  desc "Console-based Audio Visualizer for ALSA"
  homepage "https://github.com/karlstav/cava"
  url "https://github.com/karlstav/cava/archive/refs/tags/0.10.7.tar.gz"
  sha256 "43f994f7e609fab843af868d8a7bc21471ac62c5a4724ef97693201eac42e70a"
  license "MIT"
  head "https://github.com/karlstav/cava.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "ce734b6cad4e09a28b71bc21f861a2181f1d45254e2f27d1f2b6fd705484a7bd"
    sha256 cellar: :any, arm64_sequoia: "7795fd596a4671c4d2ef6c8cda1e1f6eab3b7a28bab20c9be7da4ea476207e5d"
    sha256 cellar: :any, arm64_sonoma:  "78f2072bcaa832eb5ada0a584169cc5f4f9c1aeee3e5998328dd7baf0e830227"
    sha256 cellar: :any, sonoma:        "5849239202007b3d4738a803c006224c0c6d627bacd75d615e5bee22159e69e8"
    sha256               arm64_linux:   "df962ffaf8f270bb6e60df98fa09edb6810a380ae0b52fd00e4722b30eae3003"
    sha256               x86_64_linux:  "4fbdd158121e515e5ed7bfa4f9b4645178fb65d50c9171feedba2cde7fe89a47"
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

    ENV.append "CPPFLAGS", "-I#{Formula["iniparser"].opt_include}/iniparser"
    ENV.append "LDFLAGS", "-L#{Formula["iniparser"].opt_lib}"

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
