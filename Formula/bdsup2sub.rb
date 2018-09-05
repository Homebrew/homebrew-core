class Bdsup2sub < Formula
  desc "Convert and tweak bitmap based subtitle streams"
  homepage "https://github.com/mjuhasz/BDSup2Sub"
  url "https://github.com/mjuhasz/BDSup2Sub/archive/5.1.2.tar.gz"
  sha256 "9441f1f842547a008c1878711cdc62c6656c0efea88e29bdfa6f21ac24ba87cd"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "85a39af781d4dccdd6e2915d90cd892a2c6874d70e37bcd82d5c530d64f95a88" => :mojave
    sha256 "178ef2ffa1129b31b099c923f6842302efc2b34bcbdd0e89782bf4ffc82c3c71" => :high_sierra
    sha256 "36971d050455a728d555831b7b1c554ae658bbceb6a7a26687435e04861c2bb1" => :sierra
    sha256 "59b0eccde943ecb9e614dc409ab7ddf7064479b75310c8a782bd7b777d7e25f2" => :el_capitan
  end

  depends_on "maven" => :build
  depends_on :java

  resource "macify" do
    url "https://www.java2s.com/Code/JarDownload/macify/macify-1.4.jar.zip"
    sha256 "c0ceb1b1ea3e0a59ef106ce3fe497297718ae69097a65a1519c69b8b9779c914"
  end

  resource "java-image-scaling" do
    url "https://www.java2s.com/Code/JarDownload/java-image/java-image-scaling-0.8.5.jar.zip"
    sha256 "5b082321bd40eb79072615346373b972286b63d11432f0073fcc2c3ae4bc2799"
  end

  def install
    mkdir (buildpath/"repo")
    (buildpath/"repo").install resource("macify")
    inreplace "pom.xml", "macify</groupId>", "macify</groupId>\n<scope>system</scope>\n<systemPath>${project.basedir}/repo/macify-1.4.jar</systemPath>"
    inreplace "pom.xml", %r{<repositories>(.|\n)+</repositories>}, ""
    (buildpath/"repo").install resource("java-image-scaling")
    inreplace "pom.xml", "java-image-scaling</artifactId>",
      "java-image-scaling</artifactId>\n<scope>system</scope>\n<systemPath>${project.basedir}/repo/java-image-scaling-0.8.5.jar</systemPath>"
    inreplace "pom.xml", "</properties>",
      "<maven.compiler.source>1.6</maven.compiler.source><maven.compiler.target>1.6</maven.compiler.target></properties>"

    system "mvn", "clean", "package", "-DskipTests"
    libexec.install "target/BDSup2Sub-#{version}-jar-with-dependencies.jar"
    bin.write_jar_script(libexec/"BDSup2Sub-#{version}-jar-with-dependencies.jar", "BDSup2Sub")
  end

  test do
    assert_match(/^BDSup2Sub #{version}$/, shell_output("#{bin}/BDSup2Sub -V"))
  end
end
