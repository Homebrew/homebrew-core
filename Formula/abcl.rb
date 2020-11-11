class Abcl < Formula
  desc "Armed Bear Common Lisp: a full implementation of Common Lisp"
  homepage "https://abcl.org/"
  url "https://abcl.org/releases/1.8.0/abcl-src-1.8.0.tar.gz"
  sha256 "1d871ee2f6bcf991d5a6eff7ea5105ef808610db882604d4df0411e971ad257f"
  license "GPL-2.0-or-later" => {
    with: "Classpath-exception-2.0",
  }
  head "https://abcl.org/svn/trunk/abcl/", using: :svn

  livecheck do
    url "https://abcl.org/releases/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "febebefd11614b22a01ee26b5db6284dc029e6001957394ed7d0111f845a5245" => :catalina
    sha256 "50ced025ace2e69c2ff81f6f09199eee5d9d5277c5eda0c107ab15872afdbbcb" => :mojave
    sha256 "5842be84ff71e952fa8d5144a136babc6b4a324257cd45a6b30fe2cb5a253568" => :high_sierra
  end

  depends_on "ant"
  depends_on "openjdk"
  depends_on "rlwrap"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix

    system "ant", "abcl.properties.autoconfigure.openjdk.8"
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
