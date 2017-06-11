class Abcl < Formula
  desc "Armed Bear Common Lisp: a full implementation of Common Lisp"
  homepage "http://abcl.org"
  url "http://abcl.org/releases/1.5.0/abcl-src-1.5.0.tar.gz"
  sha256 "920ee7d634a7f4ceca0a469d431d3611a321c566814d5ddb92d75950c0631bc2"
  head "http://abcl.org/svn/trunk/abcl/", :using => :svn

  bottle do
    cellar :any_skip_relocation
    sha256 "e3113086b561f7d7012f9f9bf6c4b5a771f175957fda178671dc0f3278439c73" => :sierra
    sha256 "137500452d385a1f644e47f50e6d053962ae4d179089160c41fdd4b2b6229b1c" => :el_capitan
    sha256 "c144dff67537d0aa3fb4fffa2df417ac772e8649835fa20d8fe08d6cd34aee41" => :yosemite
  end

  depends_on "ant"
  depends_on :java => "1.5+"
  depends_on "rlwrap" => :recommended

  def install
    ENV.java_cache
    system "ant"

    libexec.install "dist/abcl.jar", "dist/abcl-contrib.jar"
    (bin/"abcl").write <<-EOS.undent
      #!/bin/sh
      #{"rlwrap " if build.with?("rlwrap")}java -cp #{libexec}/abcl.jar:"$CLASSPATH" org.armedbear.lisp.Main "$@"
    EOS
  end

  test do
    (testpath/"test.lisp").write "(print \"Homebrew\")\n(quit)"
    assert_match /"Homebrew"$/, shell_output("#{bin}/abcl --load test.lisp").strip
  end
end
