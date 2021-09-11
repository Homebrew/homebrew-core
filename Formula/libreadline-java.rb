class LibreadlineJava < Formula
  desc "Port of GNU readline for Java"
  homepage "https://java-readline.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/java-readline/java-readline/0.8.0/libreadline-java-0.8.0-src.tar.gz"
  sha256 "cdcfd9910bfe2dca4cd08b2462ec05efee7395e9b9c3efcb51e85fa70548c890"
  license "LGPL-2.1-or-later"
  revision 3

  bottle do
    sha256 cellar: :any,                 big_sur:      "73b6dbaa9a738c05b8195665829637d9c4e5c1be74f7059ee17e97e2ab879e01"
    sha256 cellar: :any,                 catalina:     "cc49470dde32faf6c0621944621af9684366e6897a4994b5b021e63a8422f78e"
    sha256 cellar: :any,                 mojave:       "65444e90dded6862954e3105db11a2918554c866a1a3a344e0414d0db810f55d"
    sha256 cellar: :any,                 high_sierra:  "3dc9c829727655f811d50c6ae215b2ae3130e8c4f13c0be8e48fd5b2d62349f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d9f6b20007e15205e93081e1e21d2656915c84213b64af7c4f6c0f394018138d"
  end

  depends_on arch: :x86_64 # openjdk@8 is not supported on ARM
  depends_on "openjdk@8"
  depends_on "readline"

  # Fix "non-void function should return a value"-Error
  # https://sourceforge.net/p/java-readline/patches/2/
  patch :DATA

  def install
    java_home = Language::Java.java_home("1.8")

    # Reported 4th May 2016: https://sourceforge.net/p/java-readline/bugs/12/
    # JDK 8 doclint for Javadoc complains about minor HTML conformance issues
    if `javadoc -X`.include? "doclint"
      inreplace "Makefile",
        "-version -author org.gnu.readline test",
        "-version -author org.gnu.readline -Xdoclint:none test"
    end

    # Current Oracle JDKs put the jni.h and jni_md.h in a different place than the
    # original Apple/Sun JDK used to.
    ENV["JAVAINCLUDE"] = "#{java_home}/include"
    ENV["JAVANATINC"]  = "#{java_home}/include/#{OS.kernel_name.downcase}"

    # Take care of some hard-coded paths,
    # adjust postfix of jni libraries,
    # adjust gnu install parameters to bsd install
    inreplace "Makefile" do |s|
      s.change_make_var! "PREFIX", prefix
      s.change_make_var! "JAVALIBDIR", "$(PREFIX)/share/libreadline-java"
      s.change_make_var! "JAVAINCLUDE", ENV["JAVAINCLUDE"]
      s.change_make_var! "JAVANATINC", ENV["JAVANATINC"]
      s.gsub! "*.so", "*.jnilib" if OS.mac?
      s.gsub! "install -D", "install -c"
    end

    # Take care of some hard-coded paths,
    # adjust CC variable,
    # adjust postfix of jni libraries
    inreplace "src/native/Makefile" do |s|
      readline = Formula["readline"]
      s.change_make_var! "INCLUDES", "-I $(JAVAINCLUDE) -I $(JAVANATINC) -I #{readline.opt_include}"
      s.change_make_var! "LIBPATH", "-L#{readline.opt_lib}"
      s.change_make_var! "CC", "cc"
      if OS.mac?
        s.gsub! "LIB_EXT := so", "LIB_EXT := jnilib"
        s.gsub! "$(CC) -shared $(OBJECTS) $(LIBPATH) $($(TG)_LIBS) -o $@",
                "$(CC) -install_name #{HOMEBREW_PREFIX}/lib/$(LIB_PRE)$(TG).$(LIB_EXT) " \
                "-dynamiclib $(OBJECTS) $(LIBPATH) $($(TG)_LIBS) -o $@"
      end
    end

    pkgshare.mkpath

    system "make", "jar"
    system "make", "build-native"
    system "make", "install"

    doc.install "api"
  end

  def caveats
    <<~EOS
      You may need to set JAVA_HOME:
        export JAVA_HOME="$(/usr/libexec/java_home)"
    EOS
  end

  # Testing libreadline-java (can we execute and exit libreadline without exceptions?)
  test do
    java_path = Formula["openjdk@8"].opt_bin/"java"
    assert(/Exception/ !~ pipe_output(
      "#{java_path} -Djava.library.path=#{lib} -cp #{pkgshare}/libreadline-java.jar test.ReadlineTest",
      "exit",
    ))
  end
end

__END__
diff --git a/src/native/org_gnu_readline_Readline.c b/src/native/org_gnu_readline_Readline.c
index f601c73..b26cafc 100644
--- a/src/native/org_gnu_readline_Readline.c
+++ b/src/native/org_gnu_readline_Readline.c
@@ -430,7 +430,7 @@ const char *java_completer(char *text, int state) {
   jtext = (*jniEnv)->NewStringUTF(jniEnv,text);

   if (jniMethodId == 0) {
-    return;
+    return ((const char *)NULL);
   }

   completion = (*jniEnv)->CallObjectMethod(jniEnv, jniObject,
