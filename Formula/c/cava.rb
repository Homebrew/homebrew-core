class Cava < Formula
  desc "Console-based Audio Visualizer for ALSA"
  homepage "https://github.com/karlstav/cava"
  url "https://github.com/karlstav/cava/archive/refs/tags/0.10.7.tar.gz"
  sha256 "43f994f7e609fab843af868d8a7bc21471ac62c5a4724ef97693201eac42e70a"
  license "MIT"
  head "https://github.com/karlstav/cava.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "40bfbe3b8229358b42a646fad6d31616cf84ecc6f758d0cdf17b32f88b2e2430"
    sha256 cellar: :any, arm64_sequoia: "1016458731ecffadbafeb4a10ad4aacc307b67a11568cfb8842344012893938b"
    sha256 cellar: :any, arm64_sonoma:  "48381551d630ab4220cc39267c036c552f0ddea37afcfdfdb62f7d234009bacc"
    sha256 cellar: :any, sonoma:        "e012cc6ab3a2bbf0f76244641e809882eea9190d94f34668d2dabfe83d6401d2"
    sha256               arm64_linux:   "1e38d63792ba6bbbb12c1a1fe5d700e676f403bcce6c21681f000be9402d44e5"
    sha256               x86_64_linux:  "43eda213bfc5d7e6f33894e04be08f1a32fcea5c230a65de659d73967ee6bf6e"
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
