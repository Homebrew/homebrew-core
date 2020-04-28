class Abcl < Formula
  desc "Armed Bear Common Lisp: a full implementation of Common Lisp"
  homepage "https://abcl.org/"
  url "https://abcl.org/releases/1.6.1/abcl-src-1.6.1.tar.gz"
  sha256 "0ba1f785957ba6b9c4e5bd8df0a9881388694a00ab3651bd90718367d48abe12"
  head "https://abcl.org/svn/trunk/abcl/", :using => :svn

  bottle do
    cellar :any_skip_relocation
    sha256 "090d058ce408d836e45ea3e621c6aa1c516bcb160deb20ed56c2f31c663a87cd" => :catalina
    sha256 "637f063db889930f65280639918cd515f45faf7898bcd8e05f91ea92b0ed8965" => :mojave
    sha256 "9181e37966579df1a0554fde2be96a5de7143c6d9eaa57e45ad39d27c96704eb" => :high_sierra
  end

  depends_on "ant"
  depends_on :java => "1.8"
  depends_on "rlwrap"

  def install
    cmd = Language::Java.java_home_cmd("1.8")
    ENV["JAVA_HOME"] = Utils.popen_read(cmd).chomp

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
