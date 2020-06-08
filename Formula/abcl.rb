class Abcl < Formula
  desc "Armed Bear Common Lisp: a full implementation of Common Lisp"
  homepage "https://abcl.org/"
  url "https://abcl.org/releases/1.6.1/abcl-src-1.6.1.tar.gz"
  sha256 "0ba1f785957ba6b9c4e5bd8df0a9881388694a00ab3651bd90718367d48abe12"
  head "https://abcl.org/svn/trunk/abcl/", :using => :svn

  bottle do
    cellar :any_skip_relocation
    sha256 "11ea744886f19eead8966564d1e47e2cebcca7776fe3f4ddb6ef20e682b434ce" => :catalina
    sha256 "f04c52eb530e6d019eb937d1b96fe2de6aed506cbd195257e20ad3026427fd74" => :mojave
    sha256 "475896d9ed59f8b5448a79fa3abd0df05f12643b5004791cafb6a27441b2ac96" => :high_sierra
  end

  depends_on "ant"
  depends_on :java => "1.8"
  depends_on "rlwrap"

  def install
    cmd = Language::Java.java_home_cmd("1.8")
    ENV["JAVA_HOME"] = Utils.safe_popen_read(cmd).chomp

    system "ant"

    libexec.install "dist/abcl.jar", "dist/abcl-contrib.jar"
    (bin/"abcl").write <<~EOS
      #!/bin/sh
      export JAVA_HOME=$(#{cmd})
      rlwrap java -cp #{libexec}/abcl.jar:"$CLASSPATH" org.armedbear.lisp.Main "$@"
    EOS
  end

  test do
    (testpath/"test.lisp").write "(print \"Homebrew\")\n(quit)"
    assert_match /"Homebrew"$/, shell_output("#{bin}/abcl --load test.lisp").strip
  end
end
