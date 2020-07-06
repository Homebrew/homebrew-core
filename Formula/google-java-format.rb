class GoogleJavaFormat < Formula
  desc "Reformats Java source code to comply with Google Java Style"
  homepage "https://github.com/google/google-java-format"
  url "https://github.com/google/google-java-format/archive/google-java-format-1.8.tar.gz"
  sha256 "7ae8449441a15fc76e58d0cd69628a5e5135f01a5dea5184738c9b5ba57b525e"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "40458975314ee330d5563f305c08538a3774b3f816d43075e9509fe16dc121a5" => :catalina
    sha256 "264c72a1955375d7aecb428be58dd60c1710a1d9ef3ba242bc9a17bd185547c9" => :mojave
    sha256 "83fc6d1ca07eb27c3c9124020aa6e366815585c1e6e2d0daf90076a11844e179" => :high_sierra
  end

  depends_on "maven" => :build

  def install
    system "mvn", "versions:set", "-DnewVersion=#{version}"
    system "mvn", "install", "-DskipTests=true", "-Dmaven.javadoc.skip=true", "-B"
    libexec.install "core/target/google-java-format-#{version}-all-deps.jar"

    bin.write_jar_script libexec/"google-java-format-#{version}-all-deps.jar", "google-java-format"
  end

  test do
    (testpath/"foo.java").write "public class Foo{\n}\n"
    assert_match "public class Foo {}", shell_output("#{bin}/google-java-format foo.java")
  end
end
