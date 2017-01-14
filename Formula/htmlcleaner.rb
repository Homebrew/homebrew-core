class Htmlcleaner < Formula
  desc "HTML parser written in Java"
  homepage "http://htmlcleaner.sourceforge.net/index.php"
  url "https://downloads.sourceforge.net/project/htmlcleaner/htmlcleaner/htmlcleaner%20v2.18/htmlcleaner-2.18-src.zip"
  sha256 "d16250d038b5adc2a343fb322827575ddca95ba84887be659733bf753e7ef15b"

  bottle do
    cellar :any_skip_relocation
    sha256 "baa8a4e7b9b2968bc1d0aee422e7b1ba5306463982da62d8d2d6e7689b0937f5" => :sierra
    sha256 "0bf9827d2819dc87b93d86b08bc77c04c418483a7cb834853524174592f9f672" => :el_capitan
    sha256 "015a92188a5dc625ee57a5f2250c8c9029cfa770763d511ad9494964a6ce87a4" => :yosemite
    sha256 "334a1504f936068186b106661eb95791f7b80aa2f05382ca092c6f4c66f8756b" => :mavericks
  end

  depends_on "maven" => :build
  depends_on :java => "1.8+"

  def install
    ENV.java_cache

    system "mvn", "--log-file", "build-output.log", "clean", "package"
    libexec.install Dir["target/htmlcleaner-*.jar"]
    bin.write_jar_script "#{libexec}/htmlcleaner-#{version}.jar", "htmlcleaner"
  end

  test do
    path = testpath/"index.html"
    path.write "<html>"
    assert_match "</html>", shell_output("#{bin}/htmlcleaner src=#{path}")
  end
end
