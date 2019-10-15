class GoogleJavaFormat < Formula
  desc "Reformats Java source code to comply with Google Java Style"
  homepage "https://github.com/google/google-java-format"
  url "https://github.com/google/google-java-format/archive/google-java-format-1.7.tar.gz"
  sha256 "199c70851146bc15c8e828f5ca78d6c2d7b338def9cc70786ac3ef5967796399"

  bottle do
    cellar :any_skip_relocation
    sha256 "4b91fb104f0d8f29118adb11ca312f7ab66fb01f45373456b2f2d55e4aa8c8cc" => :catalina
    sha256 "bb1fcc168016355d6f847b858018f6c5b188f41e9461aa956a1541e609406d93" => :mojave
    sha256 "c8f23d50f6512d56d4402cb0b2325d7e01563625104579f4ea52a1f47e7f2802" => :high_sierra
    sha256 "fdd74a17bb5743a854e81d1d163f020f12d469d278bcddd1e8527c12a3752bad" => :sierra
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
