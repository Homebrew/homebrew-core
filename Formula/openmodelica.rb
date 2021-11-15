class Openmodelica < Formula
  desc "Open-source modeling and simulation tool"
  homepage "https://openmodelica.org/"
  # GitHub's archives lack submodules, must pull:
  url "https://github.com/OpenModelica/OpenModelica.git",
      tag:      "v1.18.0",
      revision: "49be4faa5a625a18efbbd74cc2f5be86aeea37bb"
  license "GPL-3.0-only"
  revision 1
  head "https://github.com/OpenModelica/OpenModelica.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "ae01ecea5750cd6029053d7bfdf03f7722fd0481b95e43182fd6ab1c74861df7"
    sha256 cellar: :any, big_sur:       "b529ee360266bccd78eae00770243d22ae7b18f801166935e4b8d7acc975b9e5"
    sha256 cellar: :any, catalina:      "bd1b777e0519fb24150ef32346a60044fad89d6e85b3f1cd31296e0906d630bc"
    sha256 cellar: :any, mojave:        "e83debeb07e63c23945af3aa3ba904bce30d28ffb4ff1213314d3a25cb90feea"
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
