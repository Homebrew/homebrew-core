class LibreadlineJava < Formula
  desc "Port of GNU readline for Java"
  homepage "https://github.com/aclemons/java-readline"
  url "https://github.com/aclemons/java-readline/releases/download/v0.8.3/libreadline-java-0.8.3-src.tar.gz"
  sha256 "57d46274b9fd18bfc5fc8b3ab751e963386144629bcfd6c66b4fae04bbf8c89f"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "30d029bd66f3e09eb495ba7fa8a7c537bb8d7c2fbf1fe92767918e74affb14db"
    sha256 cellar: :any,                 arm64_monterey: "584fd1a58765d929a2671476e64994b1de6e85da1e031d47169992afc33384a5"
    sha256 cellar: :any,                 arm64_big_sur:  "9b8326c92d05e2598c4ee4984eb1de90362e453a8a474aa3211ddb33ceb530ce"
    sha256 cellar: :any,                 ventura:        "ec976263fbef9ca431281219e95201ca2e2aa290a03302a26e3320aeb6112a76"
    sha256 cellar: :any,                 monterey:       "907febf2b1e8fd3455b7a01c04793fe3e65c07b7c35b4fe6031ad1a41535eaa3"
    sha256 cellar: :any,                 big_sur:        "3c0dcc11857d99e993ca70ec7cad6f35560988e14bb94012dedae51cfb4e936a"
    sha256 cellar: :any,                 catalina:       "7c7f86b3f0d9ba98b7e6162adb26777dd903a88ccf331428114428d3454f56d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5263653854ee8fe953985f740cf1f357ced552dac8fdd109906ba78d3190972"
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
