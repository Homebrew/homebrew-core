class GoogleJavaFormat < Formula
  desc "reformats Java source code to comply with Google Java Style."
  homepage "https://github.com/google/google-java-format"
  url "https://github.com/google/google-java-format/archive/google-java-format-1.3.tar.gz"
  sha256 "d334b9bffb8cb6c9078a5b0cc0982515226838422b3705c05934413999a69d65"

  bottle do
    cellar :any_skip_relocation
    sha256 "357c8d6fe08df50e95b426691f2822963abf62dc5c211082a7eda05ebacec897" => :sierra
    sha256 "849feab99fe3e2667b0105117ebfc3958729bd7aff4b812bc887e2cc016ea59b" => :el_capitan
    sha256 "61946ad4592bccf2cf454a5f2a9852eaf728426952b8fa2cab6c94bc66995b1f" => :yosemite
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
