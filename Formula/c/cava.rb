class Cava < Formula
  desc "Console-based Audio Visualizer for ALSA"
  homepage "https://github.com/karlstav/cava"
  url "https://github.com/karlstav/cava/archive/refs/tags/0.10.2.tar.gz"
  sha256 "853ee78729ed3501d0cdf9c1947967ad3bfe6526d66a029b4ddf9adaa6334d4f"
  license "MIT"
  head "https://github.com/karlstav/cava.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sequoia:  "6b7abdbd2b00942957380ca8770ebeb2eda39dda4ff6238afea4a46e47c45920"
    sha256 cellar: :any, arm64_sonoma:   "aa62a4d58c42b5b95be8d6f996728308730bb70eaabc4d0bf26f2599fe23e2c7"
    sha256 cellar: :any, arm64_ventura:  "480f4fb722f970d56afd1d626df91d276f0b6d8c762c53436f835dfbf8bb4df5"
    sha256 cellar: :any, arm64_monterey: "498ee144ce314d844962eef7df12b139aa5fab106dc20b6437e2ca1346bfc4a3"
    sha256 cellar: :any, sonoma:         "70e9e1476a708fe482f568f9b2f621b17eb76437e390c2ac2eaf7dc233f62edc"
    sha256 cellar: :any, ventura:        "9fad2eb551ddb104fca1a0de695586bafdd598a0189dd00156955f704d1b6921"
    sha256 cellar: :any, monterey:       "80f5dde55a22dc3e162f11f0131ed4829158f5f748c466dbed34adcf304ce8fc"
    sha256               x86_64_linux:   "9d951035501e2b9a741d8b470119a9a3223e2a361161996a4f82322664002f8b"
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

    sleep 2

    assert_match "0;0;\n", cava_stdout.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
