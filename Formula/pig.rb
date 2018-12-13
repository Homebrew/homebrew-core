class Pig < Formula
  desc "Platform for analyzing large data sets"
  homepage "https://pig.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=pig/pig-0.17.0/pig-0.17.0.tar.gz"
  mirror "https://archive.apache.org/dist/pig/pig-0.17.0/pig-0.17.0.tar.gz"
  sha256 "6d613768e9a6435ae8fa758f8eef4bd4f9d7f336a209bba3cd89b843387897f3"

  bottle :unneeded

  depends_on :java => "1.6+"

  def install
    (libexec/"bin").install "bin/pig"
    libexec.install Dir["pig-#{version}-core-h*.jar"]
    libexec.install "lib"
    (bin/"pig").write_env_script libexec/"bin/pig", Language::Java.java_home_env("1.6+").merge(:PIG_HOME => libexec)
  end

  test do
    (testpath/"test.pig").write <<~EOS
      sh echo "Hello World"
    EOS
    assert_match "Hello World", shell_output("#{bin}/pig -x local test.pig")
  end
end
