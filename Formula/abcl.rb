class Abcl < Formula
  desc "Armed Bear Common Lisp: a full implementation of Common Lisp"
  homepage "https://abcl.org/"
  url "https://abcl.org/releases/1.9.1/abcl-src-1.9.1.tar.gz"
  sha256 "2c60b23a709bb7dc661e5b5ab9f1671a922f0d064d8ff64b14536bf8bd47edf3"
  license "GPL-2.0-or-later" => {
    with: "Classpath-exception-2.0",
  }
  head "https://abcl.org/svn/trunk/abcl/", using: :svn

  livecheck do
    url "https://abcl.org/releases/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a5a4db79461f6af66607e6817167e108a69c60c9cc6c227556cd38868ff4c1a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d01ac850b99c4aa444256f8686cd3a01e8c06c6c73ecd7981aa852814370cdd4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e3a667b241dd053d248a33295e679878ea069f02b677d6ee98fa08d82d9714c8"
    sha256 cellar: :any_skip_relocation, ventura:        "3215e9fc7280cdb241b2d38455751df938ea5b9b568edf7e6db75a53b980728c"
    sha256 cellar: :any_skip_relocation, monterey:       "31034df969bab79facd7a8be6577fa9c45980fdae15b7f54ba3a47432d1e1e07"
    sha256 cellar: :any_skip_relocation, big_sur:        "41d0a03ea78425aef0aa0cc7d795119a4520c5ad5a6933976d5d04b5b71f0fdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23aea2ce0e4e89387d091108258f9c718e117edbf81f4827c9c63a6f8c1a3228"
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
    assert_match(/"Homebrew"$/, shell_output("#{bin}/abcl --load test.lisp").strip)
  end
end
