class Pig < Formula
  desc "Platform for analyzing large data sets"
  homepage "https://pig.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=pig/pig-0.18.0/pig-0.18.0.tar.gz"
  mirror "https://archive.apache.org/dist/pig/pig-0.18.0/pig-0.18.0.tar.gz"
  sha256 "6845adb936a3c3bcc71451765953cae4103e410ba2f6c5a47cc9becade0a434a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "680feb2c17ee7bbabecf33a8c7fb892d4b7b607c5a2c1497ddbfc07108d35453"
  end

  depends_on "openjdk@21"

  def install
    (libexec/"bin").install "bin/pig"
    libexec.install Dir["pig-#{version}-core-h*.jar"]
    libexec.install "lib"

    # Upstream ships commons-lang3 only under lib/spark, but hadoop 3 metrics2
    # needs it on the main classpath.
    ln_s Dir[libexec/"lib/spark/commons-lang3-*.jar"].first, libexec/"lib"

    env = Language::Java.overridable_java_home_env("21")
    env["PIG_HOME"] = libexec
    (bin/"pig").write_env_script libexec/"bin/pig", env
  end

  test do
    (testpath/"test.pig").write <<~EOS
      sh echo "Hello World"
    EOS
    assert_match "Hello World", shell_output("#{bin}/pig -x local test.pig")
  end
end
