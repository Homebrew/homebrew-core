class Htmlcleaner < Formula
  desc "HTML parser written in Java"
  homepage "https://htmlcleaner.sourceforge.io"
  url "https://downloads.sourceforge.net/project/htmlcleaner/htmlcleaner/htmlcleaner%20v2.28/htmlcleaner-2.28-src.zip"
  sha256 "1493cefbd33278d604ddc1112b85324e7fbf1e301df238983cb8607e6134a05e"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8800106897508685c78445505b5b1b54bc5c1843c0ed0e2ffed5c5116e10849b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd3c8002c0fa6b401b06cb1a8a3dbba0d5af80b595961e0478edc51630d22e5b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4f69e0c0ef7a3a3513b14d44537aba8b4eb844aef50b6e3d601d78bd6fe4c268"
    sha256 cellar: :any_skip_relocation, ventura:        "449b0dc96851b886b6a25745d12aac1db6b029cabadf844dc180a6efaab72ee4"
    sha256 cellar: :any_skip_relocation, monterey:       "807765f837ea55432354bb5dc9a21581e984c1af71e9825a9151a61fbbf67364"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce369d0824e23298c35313ba7c9e6e1bdd689229c0d78b51ac75770c4b064d32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b3b71a9096122f72681727e1af0d9b3fd0b1386dcf51454617455b9cdaaa7fa"
  end

  depends_on "maven" => :build
  depends_on "openjdk"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix
    system "mvn", "clean", "package", "-DskipTests=true", "-Dmaven.javadoc.skip=true"
    libexec.install "target/htmlcleaner-#{version}.jar"
    bin.write_jar_script libexec/"htmlcleaner-#{version}.jar", "htmlcleaner"
  end

  test do
    path = testpath/"index.html"
    path.write "<html>"
    assert_match "</html>", shell_output("#{bin}/htmlcleaner src=#{path}")
  end
end
