class GoogleJavaFormat < Formula
  desc "Reformats Java source code to comply with Google Java Style"
  homepage "https://github.com/google/google-java-format"
  url "https://github.com/google/google-java-format/archive/google-java-format-1.6.tar.gz"
  sha256 "d471a84c49ef33e1ab5059f7a04f5e1ac127ccf05db1c2d69d4c1733a256a15f"

  bottle do
    cellar :any_skip_relocation
    sha256 "8faa119a6728676caa6ca9d762259cf1362e1b0f9ba87f8785eeb9834440ad48" => :mojave
    sha256 "ca8d234d73bac0a420cf529c177deb94ecfccaa16c3e195448204f1f3dbc62e1" => :high_sierra
    sha256 "e685a06d653797ccf04b806f557378c5fc2680c4ec5b12528999615c9c79d077" => :sierra
    sha256 "b3b499ecd0ee1361a2e579882214f9d3bc0805ba676fd65f9dd0b7b59d58eef4" => :el_capitan
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
