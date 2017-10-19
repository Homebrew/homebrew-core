class GoogleJavaFormat < Formula
  desc "Reformats Java source code to comply with Google Java Style."
  homepage "https://github.com/google/google-java-format"
  url "https://github.com/google/google-java-format/archive/google-java-format-1.5.tar.gz"
  sha256 "836086fb081086abf0286d2d70acdfe4fb8bccd12f78d7967bdf440e9bf71fea"

  bottle do
    cellar :any_skip_relocation
    sha256 "c58cd25bf76abd76aeb6005d28b34096365b036db52279d05238190967e81aab" => :high_sierra
    sha256 "72c94986490c68f259b20bd78dcb5c041ef0f6d567ddc81ed737473652c5531b" => :sierra
    sha256 "7d4bd1cee1962c452582a880bfa480f7f1e42be79b2ad9ac37fdae64648b5066" => :el_capitan
    sha256 "54c538e78f8e0ff9131cd59088859c45446b366c7074b4fadeb01188e63d102e" => :yosemite
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
