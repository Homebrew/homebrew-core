class Abcl < Formula
  desc "Armed Bear Common Lisp: a full implementation of Common Lisp"
  homepage "https://abcl.org/"
  url "https://abcl.org/releases/1.7.1/abcl-src-1.7.1.tar.gz"
  sha256 "d51014b2be6ecb5bcaaacda0adf4607a995dd4b6e9e509c8a1f5a998b7649227"
  license "GPL-2.0-or-later" => {
    with: "Classpath-exception-2.0",
  }
  revision 1
  head "https://abcl.org/svn/trunk/abcl/", using: :svn

  livecheck do
    url "https://abcl.org/releases/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "bf6e2009b77b8e23c1140be6043bc51096180bd9cb8d00888caa9750eb9d1a89" => :catalina
    sha256 "1d884eb75df567889352f3a3dcd5620d92df1acdc28a219a5d1c75b06052b859" => :mojave
    sha256 "7a04bbbe48101327cbd7c08fb93c34e578a427b8dafdc2a7dbe59c213923764a" => :high_sierra
  end

  depends_on "ant"
  depends_on "openjdk"
  depends_on "rlwrap"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix

    system "ant", "abcl.properties.autoconfigure.openjdk.14"
    system "ant"

    libexec.install "dist/abcl.jar", "dist/abcl-contrib.jar"
    (bin/"abcl").write_env_script "rlwrap",
                                  "java -cp #{libexec}/abcl.jar:\"$CLASSPATH\" org.armedbear.lisp.Main",
                                  Language::Java.overridable_java_home_env
  end

  test do
    (testpath/"test.lisp").write "(print \"Homebrew\")\n(quit)"
    assert_match /"Homebrew"$/, shell_output("#{bin}/abcl --load test.lisp").strip
  end
end
