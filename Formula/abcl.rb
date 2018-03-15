class Abcl < Formula
  desc "Armed Bear Common Lisp: a full implementation of Common Lisp"
  homepage "https://abcl.org/"
  url "https://abcl.org/releases/1.5.0/abcl-src-1.5.0.tar.gz"
  sha256 "920ee7d634a7f4ceca0a469d431d3611a321c566814d5ddb92d75950c0631bc2"
  head "https://abcl.org/svn/trunk/abcl/", :using => :svn

  bottle do
    cellar :any_skip_relocation
    sha256 "dd2924e22303ac61cbd984d7f31e9d95f8c582bd2ffda0467cb1c64b7c12b3d8" => :high_sierra
    sha256 "e66f3785e8d3c018346e8e5b32cacfbcab1be4cd06d601745967037329f5bd80" => :sierra
    sha256 "9051f4c2c28fb5329d464fc491bd927cc9119ee3ff4d985d806fc51ce26c1ae2" => :el_capitan
    sha256 "3e727adfe30f0cb60d5ab05c6537db7b4670b519376c4d547e9ca8092c581320" => :yosemite
  end

  depends_on "ant"
  depends_on :java => "1.5+"
  depends_on "rlwrap" => :recommended

  def install
    system "ant"

    libexec.install "dist/abcl.jar", "dist/abcl-contrib.jar"
    (bin/"abcl").write <<~EOS
      #!/bin/sh
      #{"rlwrap " if build.with?("rlwrap")}java -cp #{libexec}/abcl.jar:"$CLASSPATH" org.armedbear.lisp.Main "$@"
    EOS
  end

  test do
    (testpath/"test.lisp").write "(print \"Homebrew\")\n(quit)"
    assert_match /"Homebrew"$/, shell_output("#{bin}/abcl --load test.lisp").strip
  end
end
