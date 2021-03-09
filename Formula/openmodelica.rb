class Openmodelica < Formula
  desc "Open-source modeling and simulation tool"
  homepage "https://openmodelica.org/"
  # GitHub's archives lack submodules, must pull:
  url "https://github.com/OpenModelica/OpenModelica.git",
    tag:      "v1.16.5",
    revision: "11fcab4f2d6895f2db073572b2bff1a43177313f"
  license "GPL-3.0-only"
  head "https://github.com/OpenModelica/OpenModelica.git"

  bottle do
    sha256 cellar: :any, big_sur:  "e6360f11e4eeaec8010b41b880867f5be1ffe445f60ce46e36ed18108b445954"
    sha256 cellar: :any, catalina: "f16736174646351d55ad03fd7af8f69b0de282adf343782216259aaf271cba36"
    sha256 cellar: :any, mojave:   "488cb4da54c5c608d9a835c58484fe7acaab4ec4edcdf258fcf5d084045533d7"
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
  uses_from_macos "libffi"
  uses_from_macos "ncurses"

  def install
    ENV.append_to_cflags "-I#{MacOS.sdk_path_if_needed}/usr/include/ffi"
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

    system "autoconf"
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
