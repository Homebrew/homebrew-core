class Gcviewer < Formula
  desc "Java garbage collection visualization tool"
  homepage "https://github.com/chewiebug/GCViewer"
  url "https://downloads.sourceforge.net/project/gcviewer/gcviewer-1.35.jar"
  sha256 "35d359a0aae175871f8d554ef1097e7f175e9f455980f6d59659f0e8d54e93f2"

  bottle :unneeded

  depends_on :java

  def install
    libexec.install Dir["*"]
    bin.write_jar_script libexec/"gcviewer-#{version}.jar", "gcviewer"
  end

  test do
    assert_predicate libexec/"gcviewer-#{version}.jar", :exist?
  end
end
