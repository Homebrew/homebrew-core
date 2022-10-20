class Openmodelica < Formula
  desc "Open-source modeling and simulation tool"
  homepage "https://openmodelica.org/"
  # GitHub's archives lack submodules, must pull:
  url "https://github.com/OpenModelica/OpenModelica.git",
      tag:      "v1.18.0",
      revision: "49be4faa5a625a18efbbd74cc2f5be86aeea37bb"
  license "GPL-3.0-only"
  revision 5
  head "https://github.com/OpenModelica/OpenModelica.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "e1dcceb4223c158ba220cc251df363ed17487a71040481c93a8841d99f033fd9"
    sha256 cellar: :any, arm64_big_sur:  "12560cb01f7173ddce34b6eeea6b64754c80c53c5baa814bab6b7b65df64669f"
    sha256 cellar: :any, monterey:       "7426c175af57dff3de8846c92c914a8ca15bfeb7d22613b16db3ca56cadef5af"
    sha256 cellar: :any, big_sur:        "477776d794603c9bf0344cdb387a8b392849c34b1d57d5c2fa4a0e97974b5ceb"
    sha256 cellar: :any, catalina:       "f6a44593ad46bf8607112c3925dd18541f72089f64bafa1ca21387c1b30e3462"
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

  # Fix -flat_namespace being used on Big Sur and later.
  # We patch `libtool.m4` and not `configure` because we call `autoreconf`
  patch :DATA

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

__END__
--- a/OMCompiler/3rdParty/lis-1.4.12/m4/libtool.m4
+++ b/OMCompiler/3rdParty/lis-1.4.12/m4/libtool.m4
@@ -1067,16 +1067,11 @@ _LT_EOF
       _lt_dar_allow_undefined='$wl-undefined ${wl}suppress' ;;
     darwin1.*)
       _lt_dar_allow_undefined='$wl-flat_namespace $wl-undefined ${wl}suppress' ;;
-    darwin*) # darwin 5.x on
-      # if running on 10.5 or later, the deployment target defaults
-      # to the OS version, if on x86, and 10.4, the deployment
-      # target defaults to 10.4. Don't you love it?
-      case ${MACOSX_DEPLOYMENT_TARGET-10.0},$host in
-	10.0,*86*-darwin8*|10.0,*-darwin[[91]]*)
-	  _lt_dar_allow_undefined='$wl-undefined ${wl}dynamic_lookup' ;;
-	10.[[012]][[,.]]*)
+    darwin*)
+      case ${MACOSX_DEPLOYMENT_TARGET},$host in
+	10.[[012]],*|,*powerpc*)
 	  _lt_dar_allow_undefined='$wl-flat_namespace $wl-undefined ${wl}suppress' ;;
-	10.*)
+	*)
 	  _lt_dar_allow_undefined='$wl-undefined ${wl}dynamic_lookup' ;;
       esac
     ;;
