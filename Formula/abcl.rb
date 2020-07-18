class Abcl < Formula
  desc "Armed Bear Common Lisp: a full implementation of Common Lisp"
  homepage "https://abcl.org/"
  url "https://abcl.org/releases/1.7.1/abcl-src-1.7.1.tar.gz"
  sha256 "d51014b2be6ecb5bcaaacda0adf4607a995dd4b6e9e509c8a1f5a998b7649227"
  head "https://abcl.org/svn/trunk/abcl/", :using => :svn

  bottle do
    cellar :any_skip_relocation
    sha256 "01dc891257763b86376f4103cac1696f3614d5a066ecdf6665f6ac3b4a1cce4a" => :catalina
    sha256 "fc0dc598a3ddfdf3da5cebb18dd554df41306bcba0bbc60a9e5a0f51e5c4b653" => :mojave
    sha256 "eb1906d87ae88108910d59bae0146fccab67220ae99f9161b88502f6863e5ee2" => :high_sierra
  end

  depends_on "ant"
  depends_on :java => "1.8"
  depends_on "rlwrap"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("1.8")

    system "ant"

    libexec.install "dist/abcl.jar", "dist/abcl-contrib.jar"
    (bin/"abcl").write_env_script "rlwrap",
                                  "java -cp #{libexec}/abcl.jar:\"$CLASSPATH\" org.armedbear.lisp.Main \"$@\"",
                                  Language::Java.overridable_java_home_env("1.8")
  end

  test do
    (testpath/"test.lisp").write "(print \"Homebrew\")\n(quit)"
    assert_match /"Homebrew"$/, shell_output("#{bin}/abcl --load test.lisp").strip
  end
end
