class GoogleJavaFormat < Formula
  desc "Reformats Java source code to comply with Google Java Style."
  homepage "https://github.com/google/google-java-format"
  url "https://github.com/google/google-java-format/archive/google-java-format-1.5.tar.gz"
  sha256 "836086fb081086abf0286d2d70acdfe4fb8bccd12f78d7967bdf440e9bf71fea"

  bottle do
    cellar :any_skip_relocation
    sha256 "6518d97e039cf09bd0924b79f0b7f65cb37791c076277777f90d2db76beac26d" => :high_sierra
    sha256 "9128ee4d7c2b0d38f53320e6e0875caeae4304cfd2534cbdf2db9b23ee8df003" => :sierra
    sha256 "89b4ebce9de9785c672e93567aeb1f6b4b1ea13161277d59b677fb0e04889ba5" => :el_capitan
  end

  depends_on "maven" => :build

  def install
    system "mvn", "install", "-DskipTests=true", "-Dmaven.javadoc.skip=true", "-B"
    libexec.install "core/target/google-java-format-#{version}-all-deps.jar"

    bin.write_jar_script libexec/"google-java-format-#{version}-all-deps.jar", "google-java-format"
  end

  test do
    (testpath/"foo.java").write "public class Foo{\n}\n"
    assert_match "public class Foo {}", shell_output("#{bin}/google-java-format foo.java")
  end
end
