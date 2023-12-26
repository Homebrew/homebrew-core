class Mahout < Formula
  desc "Library to help build scalable machine learning libraries"
  homepage "https://mahout.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=mahout/14.1/apache-mahout-distribution-14.1.tar.gz"
  mirror "https://archive.apache.org/dist/mahout/14.1/apache-mahout-distribution-14.1.tar.gz"
  sha256 "95cca01a56292488f86a0b8c16b18622e50882fcb4795c3d6872e315a213f0b9"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "3b7e05dbbd5838236245dd37e3ed7a1cc10d4dd151adbc7979b345cb19daab0e"
  end

  head do
    url "https://github.com/apache/mahout.git", branch: "trunk"
    depends_on "maven" => :build
  end

  depends_on "hadoop"
  depends_on "openjdk@11"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("11")

    if build.head?
      chmod 755, "./bin"
      system "mvn", "-DskipTests", "clean", "install"
    end

    libexec.install "bin"

    if build.head?
      libexec.install Dir["buildtools/target/*.jar"]
      libexec.install Dir["core/target/*.jar"]
      libexec.install Dir["examples/target/*.jar"]
      libexec.install Dir["math/target/*.jar"]
    else
      libexec.install Dir["*.jar"]
    end

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files libexec/"bin", JAVA_HOME: ENV["JAVA_HOME"]
  end

  test do
    (testpath/"test.csv").write <<~EOS
      "x","y"
      0.1234567,0.101201201
    EOS

    assert_match "0.101201201", pipe_output("#{bin}/mahout cat #{testpath}/test.csv")
  end
end
