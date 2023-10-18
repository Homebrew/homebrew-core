class Cava < Formula
  desc "Console-based Audio Visualizer for ALSA"
  homepage "https://github.com/karlstav/cava"
  url "https://github.com/karlstav/cava/archive/0.9.1.tar.gz"
  sha256 "483f571d5fba5fb8aa81511c4dcf8ce0949c7c503ec6c743c2914cd78e6faf03"
  license "MIT"
  head "https://github.com/karlstav/cava.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9a46dffaab5df80aa54dde50aae4ee545455e7ebc15de0c7ba7833d68f5c1d8e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac2b96b1143b50f4e9a3a7affd3c30443782e7374aa225e87c56d68cde1d96d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "971a6df81f5786fce43826fb1de9bddbf2cb18c887edcd8d7acb328bd2a21ae4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c72b5b7c8c00b65bfc8fc518bebcb79c7049e381fc79c95f19d4203b51727e59"
    sha256 cellar: :any,                 sonoma:         "5fd9f94f25d1f79eea3aeff8cabb081fd079c2a66c0af0a88332aff62e4be991"
    sha256 cellar: :any_skip_relocation, ventura:        "2b31c8273c26f2f94be048113829a2f28201c123755dd52227a892bdba7e321e"
    sha256 cellar: :any_skip_relocation, monterey:       "8c3fe61d1f23dfccb3cdd3589326236b9a7ef583566c79f8185ac64f8dd0dad3"
    sha256 cellar: :any_skip_relocation, big_sur:        "5cc5a84eba5949107af333fe87ed0e67450b3428e6bbbaf8a566cc9ae5e87261"
    sha256                               x86_64_linux:   "9cca26389fd36d918e11746dabc681c8331a15aa9cfef87f7f0018ebfb19d2e6"
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
