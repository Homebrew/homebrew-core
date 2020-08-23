class Abcl < Formula
  desc "Armed Bear Common Lisp: a full implementation of Common Lisp"
  homepage "https://abcl.org/"
  url "https://abcl.org/releases/1.7.1/abcl-src-1.7.1.tar.gz"
  sha256 "d51014b2be6ecb5bcaaacda0adf4607a995dd4b6e9e509c8a1f5a998b7649227"
  head "https://abcl.org/svn/trunk/abcl/", using: :svn

  bottle do
    cellar :any_skip_relocation
    sha256 "dbc8cab34a0b85cecce84c864f1d5dd74ef8c2198a3fad8bb2af9d4c7ddc2fcd" => :catalina
    sha256 "45bc3d5c2c85d573b80f2c25f5768db473a1c6d33ae21174a86d3b74b5b9de6f" => :mojave
    sha256 "4fbe880deca89206aa02449714952524ee6399381233ad029d6ed119412831b4" => :high_sierra
  end

  depends_on "ant"
  depends_on java: "1.8"
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
