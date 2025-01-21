class Cava < Formula
  desc "Console-based Audio Visualizer for ALSA"
  homepage "https://github.com/karlstav/cava"
  url "https://github.com/karlstav/cava/archive/refs/tags/0.10.3.tar.gz"
  sha256 "bf822ac18ae0ca2cf926c2875f3221591960c25f2bcab89ea19729be4b9c3663"
  license "MIT"
  head "https://github.com/karlstav/cava.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "542e3b1a6e1afc56696d15da1e7687dad07172b86b8bfc490225a6187efe0ede"
    sha256 cellar: :any, arm64_sonoma:  "13aded048f357625802864e2067ccdbf358bfc334c041d055c06cdb691f67463"
    sha256 cellar: :any, arm64_ventura: "69f94af1c238347ce18b1c7c5c2d2c91290fbbb6f2c8db2fcfa62b6bb371757e"
    sha256 cellar: :any, sonoma:        "3797dfa8b39311aac363f40d6dfb8b1d5154def13f6b99279f128492ba36e1d3"
    sha256 cellar: :any, ventura:       "f2a6956deb87d8920b59dd98a739c89d00c93eed8f7b4ed7276199710d1e093f"
    sha256               x86_64_linux:  "a9f74b99e1f3fa902de09d21c022681cce3a9e90af4aa6ee1dd1e5f0dcc6506c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool"  => :build
  depends_on "pkgconf"  => :build

  depends_on "fftw"
  depends_on "iniparser"
  depends_on "portaudio"

  uses_from_macos "vim" => :build # needed for xxd
  uses_from_macos "ncurses"

  on_linux do
    depends_on "alsa-lib"
    depends_on "jack"
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
