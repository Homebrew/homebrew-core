class Openmodelica < Formula
  desc "Open-source modeling and simulation tool"
  homepage "https://openmodelica.org/"
  # GitHub's archives lack submodules, must pull:
  url "https://github.com/OpenModelica/OpenModelica.git",
      tag:      "v1.18.0",
      revision: "49be4faa5a625a18efbbd74cc2f5be86aeea37bb"
  license "GPL-3.0-only"
  head "https://github.com/OpenModelica/OpenModelica.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, big_sur:  "bffa7dc5380a70a9d158ff22277113396ed4d9102308531c2addd12f4e10d9e1"
    sha256 cellar: :any, catalina: "bf668ccb74f44cac73702fa18f7561c38b86ed97195e3c0b3300b541caf92593"
    sha256 cellar: :any, mojave:   "1754d9ab98671cd3b2a9af2dbd09553370a63fd41eb05797f7ff3c52d367daa0"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "gcc" => :build # for gfortran
  depends_on "gnu-sed" => :build
  depends_on "libtool" => :build
  depends_on "openjdk" => :build
  depends_on "pkg-config" => :build

  depends_on "boost"
  depends_on "gettext"
  depends_on "hdf5"
  depends_on "hwloc"
  depends_on "lp_solve"
  depends_on "omniorb"
  depends_on "openblas"
  depends_on "qt@5"
  depends_on "readline"
  depends_on "sundials"

  uses_from_macos "curl"
  uses_from_macos "expat"
  uses_from_macos "libffi", since: :catalina
  uses_from_macos "ncurses"

  def install
    if MacOS.version >= :catalina
      ENV.append_to_cflags "-I#{MacOS.sdk_path_if_needed}/usr/include/ffi"
    else
      ENV.append_to_cflags "-I#{Formula["libffi"].opt_include}"
    end
    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --disable-modelica3d
      --with-cppruntime
      --with-hwloc
      --with-lapack=-lopenblas
      --with-omlibrary=core
      --with-omniORB
    ]

    system "autoreconf", "--install", "--verbose", "--force"
    system "./configure", *args
    # omplot needs qt & OpenModelica #7240.
    # omparser needs OpenModelica #7247
    # omshell, omedit, omnotebook, omoptim need QTWebKit: #19391 & #19438
    # omsens_qt fails with: "OMSens_Qt is not supported on MacOS"
    system "make", "omc", "omlibrary-core", "omsimulator"
    prefix.install Dir["build/*"]
  end

  test do
    system "#{bin}/omc", "--version"
    system "#{bin}/OMSimulator", "--version"
    (testpath/"test.mo").write <<~EOS
      model test
      Real x;
      initial equation x = 10;
      equation der(x) = -x;
      end test;
    EOS
    assert_match "class test", shell_output("#{bin}/omc #{testpath/"test.mo"}")
  end
end
