class Pig < Formula
  desc "Platform for analyzing large data sets"
  homepage "https://pig.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=pig/pig-0.15.0/pig-0.15.0.tar.gz"
  mirror "https://archive.apache.org/dist/pig/pig-0.15.0/pig-0.15.0.tar.gz"
  sha256 "c52112ca618daaca298cf068e6451449fe946e8dccd812d56f8f537aa275234b"

  bottle :unneeded

  depends_on :java => "1.6+"

  def install
    (libexec/"bin").install "bin/pig"
    libexec.install ["pig-#{version}-core-h1.jar", "pig-#{version}-core-h2.jar", "lib"]
    (bin/"pig").write_env_script libexec/"bin/pig", Language::Java.java_home_env("1.6+").merge(:PIG_HOME => libexec)
  end

  test do
    (testpath/"test.pig").write <<-EOS.undent
      sh echo "Hello World"
    EOS
    assert_match "Hello World", shell_output("#{bin}/pig -x local test.pig")
  end
end
