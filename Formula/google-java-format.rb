class GoogleJavaFormat < Formula
  desc "reformats Java source code to comply with Google Java Style."
  homepage "https://github.com/google/google-java-format"
  url "https://github.com/google/google-java-format/archive/google-java-format-1.2.tar.gz"
  sha256 "d8ec631f04d44c6035ed762ccc414ac312aced80acf2223a27acbe22f87bb8c6"

  bottle do
    cellar :any_skip_relocation
    sha256 "cd02ff7d091b8a70fd5a70b708f0a2782f023ce61fc2b9f971c2f1af75647e19" => :sierra
    sha256 "112ab893b27010c93d31a6d2328fd3b0179c962bf1d84420634d878dd6453dff" => :el_capitan
    sha256 "7fbf50feec06fea5760971ce8202f9704effdb500ee6728ae3eb65a18523cf4e" => :yosemite
  end

  depends_on "maven" => :build

  def install
    ENV.java_cache

    system "mvn", "install", "-DskipTests=true", "-Dmaven.javadoc.skip=true", "-B"
    libexec.install "core/target/google-java-format-#{version}-all-deps.jar"

    bin.write_jar_script libexec/"google-java-format-#{version}-all-deps.jar", "google-java-format"
  end

  test do
    (testpath/"foo.java").write "public class Foo{\n}\n"
    assert_match "public class Foo {}", shell_output("#{bin}/google-java-format foo.java")
  end
end
