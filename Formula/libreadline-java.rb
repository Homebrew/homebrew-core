class LibreadlineJava < Formula
  desc "Port of GNU readline for Java"
  homepage "https://github.com/aclemons/java-readline"
  url "https://github.com/aclemons/java-readline/releases/download/v0.8.3/libreadline-java-0.8.3-src.tar.gz"
  sha256 "57d46274b9fd18bfc5fc8b3ab751e963386144629bcfd6c66b4fae04bbf8c89f"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 monterey:     "d3c2093a2b4e600f92bf0f717d3db850c3e47fd78c00d7bac2fabf400daa7c80"
    sha256 cellar: :any,                 big_sur:      "73b6dbaa9a738c05b8195665829637d9c4e5c1be74f7059ee17e97e2ab879e01"
    sha256 cellar: :any,                 catalina:     "cc49470dde32faf6c0621944621af9684366e6897a4994b5b021e63a8422f78e"
    sha256 cellar: :any,                 mojave:       "65444e90dded6862954e3105db11a2918554c866a1a3a344e0414d0db810f55d"
    sha256 cellar: :any,                 high_sierra:  "3dc9c829727655f811d50c6ae215b2ae3130e8c4f13c0be8e48fd5b2d62349f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d9f6b20007e15205e93081e1e21d2656915c84213b64af7c4f6c0f394018138d"
  end

  depends_on "openjdk"
  depends_on "readline"

  def install
    ENV["JAVA_HOME"] = java_home = Language::Java.java_home

    # Current Oracle JDKs put the jni.h and jni_md.h in a different place than the
    # original Apple/Sun JDK used to.
    ENV["JAVAINCLUDE"] = "#{java_home}/include"
    ENV["JAVANATINC"]  = "#{java_home}/include/#{OS.kernel_name.downcase}"

    # Take care of some hard-coded paths,
    # adjust postfix of jni libraries,
    # adjust gnu install parameters to bsd install
    inreplace "Makefile" do |s|
      s.change_make_var! "PREFIX", prefix
      s.change_make_var! "JAVAC_VERSION", Formula["openjdk"].version
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
        s.change_make_var! "LIB_EXT", "jnilib"
        s.change_make_var! "LD_FLAGS", "-install_name #{HOMEBREW_PREFIX}/lib/$(LIB_PRE)$(TG).$(LIB_EXT) -dynamiclib"
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
    java_path = Formula["openjdk"].opt_bin/"java"
    assert(/Exception/ !~ pipe_output(
      "#{java_path} -Djava.library.path=#{lib} -cp #{pkgshare}/libreadline-java.jar test.ReadlineTest",
      "exit",
    ))
  end
end
