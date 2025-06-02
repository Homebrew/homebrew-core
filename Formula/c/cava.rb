class Cava < Formula
  desc "Console-based Audio Visualizer for ALSA"
  homepage "https://github.com/karlstav/cava"
  url "https://github.com/karlstav/cava/archive/refs/tags/0.10.4.tar.gz"
  sha256 "5a2efedf2d809d70770f49349f28a5c056f1ba9b3f5476e78744291a468e206a"
  license "MIT"
  head "https://github.com/karlstav/cava.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "fc71ed1ee831644035fdce90d1a95ec22e6b628cf8272fe021a96c541915a5a3"
    sha256 cellar: :any, arm64_sonoma:  "5dbaed52f9b4450cda2ee03f98538d49f9d8a071a637a4ec583a1f112d86e404"
    sha256 cellar: :any, arm64_ventura: "9a28fd6da1772968860f7e90e7f4de6d3f733e9f8131d4cc35ea0d089207b681"
    sha256 cellar: :any, sonoma:        "4195486bcc4c14f0c9dfa0f229ef4a2f17a577132b50e402af480df0263ed5bd"
    sha256 cellar: :any, ventura:       "fc4e24b6e06d3c7b6839fe7c9ddf089cb874e2cf3b2b69ae98fa21ca21c9cf2e"
    sha256               arm64_linux:   "a47b2f16fb7660eea601173a303838c4b7d56f317f152afef4369fa9b5d96c84"
    sha256               x86_64_linux:  "e85e6e26804aff07eb2d748904dd810a1427d2cbd3e328e912356fcace9102e1"
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
