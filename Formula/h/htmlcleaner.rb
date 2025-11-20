class Htmlcleaner < Formula
  desc "HTML parser written in Java"
  homepage "https://htmlcleaner.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/htmlcleaner/htmlcleaner/htmlcleaner%20v2.29/htmlcleaner-src-2.29.zip"
  sha256 "9fc68d7161be6f34f781e109bf63894d260428f186d88f315b1d2e3a33495350"
  license "BSD-3-Clause"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "481e7ce48a7dc9bddaa359cd8b30412f993266133f606e0970031feb20a3e924"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ee4cfa168e59ef59a77de847f53f23c4f9a2a7be9a1f1844608c72b5ff1b7af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35348580167a179573bf545a60831a398a8d70a0c567d313acdb1707d9068d15"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b8823d1ba1ef2e847fe95da75054ec681d3aafcafef2c1bf084b7f917c02884c"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e7f1b1c468d1a5ead2ed450fed70e621ee5b429486da31ac05474d9871473ed"
    sha256 cellar: :any_skip_relocation, ventura:       "8dc19a84c07fee65cef8e0889cae31a1e9f1a437f78911808340bbaf5a7a9a2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0cdd1dd6b3a16f874d8980cc78f599dddc97713c322b5e8f962a7cf88810efd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49d3b92068ee5e037f6efe9232227d6b49069c0f6e0a09a1abd34467290755b1"
  end

  depends_on "maven" => :build
  depends_on "openjdk"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home
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
