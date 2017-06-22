class GoogleJavaFormat < Formula
  desc "Reformats Java source code to comply with Google Java Style."
  homepage "https://github.com/google/google-java-format"
  url "https://github.com/google/google-java-format/archive/google-java-format-1.3.tar.gz"
  sha256 "d334b9bffb8cb6c9078a5b0cc0982515226838422b3705c05934413999a69d65"

  bottle do
    cellar :any_skip_relocation
    sha256 "e393dae7521416a76d31067874a8633cf80a79531a78085b8ff836a9049c7886" => :sierra
    sha256 "7f4cd5af0fe23370d5f494dad918ff1454a699a073d9a63496249cc614dbe6a7" => :el_capitan
    sha256 "02374c403254edb8e69e164030f634850ae4bea8907622dd4d78731922c1e1fb" => :yosemite
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
