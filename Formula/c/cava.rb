class Cava < Formula
  desc "Console-based Audio Visualizer for ALSA"
  homepage "https://github.com/karlstav/cava"
  url "https://github.com/karlstav/cava/archive/refs/tags/0.10.6.tar.gz"
  sha256 "b1ce6653659a138cbaebf0ef2643a1569525559c597162e90bf9304ac8781398"
  license "MIT"
  head "https://github.com/karlstav/cava.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c421542c3581b9cae41580a3887629139b91349b35ee9b0895e8d1227b4b50d7"
    sha256 cellar: :any, arm64_sequoia: "334969b0165063868eae0939daf699d41dba964e7ae8a23e38b8a13509cfda64"
    sha256 cellar: :any, arm64_sonoma:  "07df7109a204021ff71a40549cce4b501068202042013afdeecd76377e5d79ed"
    sha256 cellar: :any, arm64_ventura: "1f1500c5185be5012d79139a50d6a57381bcf64caa321c2cc3b290af89bae4fd"
    sha256 cellar: :any, sonoma:        "45f2092f455d81b05679d70223017d74e263299fd0a1e3c1dd43cd2d32f6088f"
    sha256 cellar: :any, ventura:       "0fce634640d2113ada60209af6796d063a43f4d5b4a8b3d9956b811b311ff4ff"
    sha256               arm64_linux:   "31f97961aee0b8d17b33a20c5c7f9866038efa26cad0fceb56d023355c1f162d"
    sha256               x86_64_linux:  "f008fbafb2cd10604b212ba163ccb1cb168f3f1927ad65d50f4dabe36e7aa562"
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
