class Mesos < Formula
  desc "Apache cluster manager"
  homepage "https://mesos.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=mesos/1.11.0/mesos-1.11.0.tar.gz"
  mirror "https://archive.apache.org/dist/mesos/1.11.0/mesos-1.11.0.tar.gz"
  sha256 "ce08cb648a21502a4a0c45d240a596d9ac860fcaf717f9a3dc986da9d406fe34"
  license "Apache-2.0"

  bottle do
    sha256 big_sur:  "05b5c4234338601c5fde42b7c692970d037ce6c5952dd615e5148be8dfde7c6e"
    sha256 catalina: "7b94becb34b33903ab43411a814514cb40c82facf216480aff9c12e9125b684a"
    sha256 mojave:   "4703f4fb7376a394f08e4b44bd90f2eacefc409e38350290dd131371892c89bb"
  end

  # See https://lists.apache.org/thread.html/rab2a820507f7c846e54a847398ab20f47698ec5bce0c8e182bfe51ba@<dev.mesos.apache.org>
  disable! date: "2022-07-31", because: :deprecated_upstream

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "maven" => :build
  depends_on "apr-util"
  depends_on "openjdk@8"
  depends_on "subversion"

  conflicts_with "nanopb-generator", because: "they depend on an incompatible version of protobuf"
  conflicts_with "rapidjson", because: "mesos installs a copy of rapidjson headers"

  def install
    # Disable optimizing as libc++ does not play well with optimized clang
    # builds (see https://llvm.org/bugs/show_bug.cgi?id=28469 and
    # https://issues.apache.org/jira/browse/MESOS-5745).
    #
    # NOTE: We cannot use `--disable-optimize` since we also pass e.g.,
    # CXXFLAGS via environment variables. Since compiler flags are passed via
    # environment variables the Mesos build will silently ignore flags like
    # `--[disable|enable]-optimize`.
    ENV.O0 unless DevelopmentTools.clang_build_version >= 900

    ENV.cxx11

    # macOS no longer provides JavaVM.framework. Fix configure script
    # that assumes this framework exists for JNI linking.
    ENV["JAVA_CPPFLAGS"] = "-I#{Formula["openjdk@8"].include}"
    ENV["JAVA_HOME"] = Language::Java.java_home("1.8")
    ENV["JAVA_TEST_LDFLAGS"] = "-L#{ENV["JAVA_HOME"]}/jre/lib/server -ljvm"
    inreplace "configure", "-framework JavaVM", ENV["JAVA_TEST_LDFLAGS"]

    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-apr=#{Formula["apr"].opt_libexec}",
                          "--with-svn=#{Formula["subversion"].opt_prefix}",
                          "--disable-python"
    system "make"
    system "make", "install"

    bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env("1.8"))
    sbin.env_script_all_files(libexec/"sbin", Language::Java.java_home_env("1.8"))
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/mesos-agent --version")
    assert_match version.to_s, shell_output("#{sbin}/mesos-master --version")
    assert_match "Usage: mesos", shell_output("#{bin}/mesos 2>&1", 1)
  end
end
