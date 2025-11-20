class LibreadlineJava < Formula
  desc "Port of GNU readline for Java"
  homepage "https://github.com/aclemons/java-readline"
  url "https://github.com/aclemons/java-readline/releases/download/v0.8.4/libreadline-java-0.8.4-src.tar.gz"
  sha256 "8767f1e5ba01c5bece9401871b318e9a28607d199a14def7a7bcb495059c2958"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/^[vR]?_?(\d+(?:[._-]\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c0be01dc30e16481895ced158022bde0abd47698532406fe694974695f028e17"
    sha256 cellar: :any,                 arm64_sequoia: "52f86fbe9c1b82c3514d13d7a9c4e60cee6f3bf387290ae7ce0ebba3bc98a106"
    sha256 cellar: :any,                 arm64_sonoma:  "d39da0a4d0597ea0994146549145565b00a23277a2d080fc94391afd0a98d502"
    sha256 cellar: :any,                 arm64_ventura: "94452a56ce5ffe31e34c87c1778f4e761cbe498ab566344072578d699c8e46b5"
    sha256 cellar: :any,                 sonoma:        "214bbffd99c95123e7b2fbb4758ae0d911a39d3ca0fc03d9c5fab6429109edc2"
    sha256 cellar: :any,                 ventura:       "e8b5eef43662b6594f6bf0e4d0fb222da1ed6526eb5c11a0e4d1d97d54f9f184"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6bbf05f7d0a1176b8daf2dd9d01da8bf1708abe03c3c34506ce9b78f327cc341"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8ae93ee446d1a424cb6d17d8103d0a86fc0d964b0247852cc710872897349b8"
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
      s.change_make_var! "JAVAC_VERSION", Formula["openjdk"].version.to_s
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
