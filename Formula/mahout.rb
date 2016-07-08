class Mahout < Formula
  desc "Library to help build scalable machine learning libraries"
  homepage "https://mahout.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=mahout/0.12.2/apache-mahout-distribution-0.12.2.tar.gz"
  sha256 "8e9d9fb04c6f1cfc11932a8cf268dea87460ffdd50aa0355db7cd470d0420946"

  head do
    url "https://github.com/apache/mahout.git"
    depends_on "maven" => :build
  end

  bottle :unneeded

  depends_on "hadoop"
  depends_on :java

  def install
    if build.head?
      ENV.java_cache

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
    bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env)
  end

  test do
    (testpath/"test.csv").write <<-EOS.undent
      "x","y"
      0.1234567,0.101201201
    EOS

    assert_match "0.101201201", pipe_output("#{bin}/mahout cat #{testpath}/test.csv")
  end
end
