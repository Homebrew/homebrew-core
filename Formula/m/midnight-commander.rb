class MidnightCommander < Formula
  desc "Terminal-based visual file manager"
  homepage "https://www.midnight-commander.org/"
  url "https://www.midnight-commander.org/downloads/mc-4.8.30.tar.xz"
  mirror "https://ftp.osuosl.org/pub/midnightcommander/mc-4.8.30.tar.xz"
  sha256 "5ebc3cb2144b970c5149fda556c4ad50b78780494696cdf2d14a53204c95c7df"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://ftp.osuosl.org/pub/midnightcommander/"
    regex(/href=.*?mc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "4c0bfce930eb62095fd5275b107d113416157d42a69fd30f9213534f26f62fc1"
    sha256 arm64_ventura:  "6c9997cc0e3abe409b02fc2f5b834e5c805d4c01bace1b1e8930dbf5bda9974d"
    sha256 arm64_monterey: "e87079b81d73cb205be44d7b37761d004dae2edb14d62fe3791e34a2ac27fd38"
    sha256 arm64_big_sur:  "b63985ce7b866b053613f2847d2b68f3145d8807d6e9ca49bb08757676f4c627"
    sha256 sonoma:         "29c0e3f694160431f32f0847662af4264454fe98131472b6f8331c43f3bb57dc"
    sha256 ventura:        "83f00b049d08761da7b730ab73cf05acfbb03c2982b17abdbd59d810c3a6aab5"
    sha256 monterey:       "5f996907eea175493f1a42d8bf88e6eb3f0ef3d2d456b1c3480b2a8092adc8e2"
    sha256 big_sur:        "a9fa1931be3b67b41358cb328304781010fd8d5984c5337a13749aafe8b1f2f0"
    sha256 x86_64_linux:   "f901b34e155fff6a4cb2acc7e011ec2ad88d03d3129b8db7815db432eb0a8b0a"
  end

  head do
    url "https://github.com/MidnightCommander/mc.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libssh2"
  depends_on "openssl@3"
  depends_on "s-lang"

  conflicts_with "minio-mc", because: "both install an `mc` binary"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --without-x
      --with-screen=slang
      --enable-vfs-sftp
    ]

    # Fix compilation bug on macOS 10.13 by pretending we don't have utimensat()
    # https://github.com/MidnightCommander/mc/pull/130
    ENV["ac_cv_func_utimensat"] = "no" if OS.mac? && MacOS.version >= :high_sierra
    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"

    inreplace share/"mc/syntax/Syntax", Superenv.shims_path, "/usr/bin" if OS.mac?
  end

  test do
    assert_match "GNU Midnight Commander", shell_output("#{bin}/mc --version")
  end
end
