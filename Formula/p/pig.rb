class Pig < Formula
  desc "Platform for analyzing large data sets"
  homepage "https://pig.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=pig/pig-0.17.0/pig-0.17.0.tar.gz"
  mirror "https://archive.apache.org/dist/pig/pig-0.17.0/pig-0.17.0.tar.gz"
  sha256 "6d613768e9a6435ae8fa758f8eef4bd4f9d7f336a209bba3cd89b843387897f3"
  license "Apache-2.0"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "c64b39772253801fc72a6400bdbed3245bbd4308c78fc08ad329a1ce1781840a"
  end

  depends_on "openjdk@17"

  def install
    (libexec/"bin").install "bin/pig"
    libexec.install Dir["pig-#{version}-core-h*.jar"]
    libexec.install "lib"

    env = Language::Java.overridable_java_home_env("17")
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
