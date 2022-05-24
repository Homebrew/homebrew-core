class Mahout < Formula
  desc "Library to help build scalable machine learning libraries"
  homepage "https://mahout.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=mahout/0.13.0/apache-mahout-distribution-0.13.0.tar.gz"
  mirror "https://archive.apache.org/dist/mahout/0.13.0/apache-mahout-distribution-0.13.0.tar.gz"
  sha256 "87bdc86e16b5817d6b5a810b94d7389604887f7de9c680f34faaf0cbb8dabf6f"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "baaec00c1e35a0a264b4ef3d0e7e5043f4ea8dfb264d3df278bd5fc629d7faf0"
  end

  head do
    url "https://github.com/apache/mahout.git"
    depends_on "maven" => :build
  end

  depends_on "hadoop"
  depends_on "openjdk"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix

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
