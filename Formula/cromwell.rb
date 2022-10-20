class Cromwell < Formula
  desc "Workflow Execution Engine using Workflow Description Language"
  homepage "https://github.com/broadinstitute/cromwell"
  url "https://github.com/broadinstitute/cromwell/releases/download/84/cromwell-84.jar"
  sha256 "faf6e7996e1c2e9e4e71f2256f984e3a7782df9377fd2ccd32546f622d05cb2b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2aacb5acac2682c8437112b65935980ead16dfe5344ad0a02395ed9fe7484ce7"
  end

  head do
    url "https://github.com/broadinstitute/cromwell.git", branch: "develop"
    depends_on "sbt" => :build
  end

  depends_on "openjdk"

  resource "womtool" do
    url "https://github.com/broadinstitute/cromwell/releases/download/84/womtool-84.jar"
    sha256 "784604988807fb60d0b8336d0731f2bce551358e4211c31458889eec9dbf8ad9"
  end

  def install
    if build.head?
      system "sbt", "assembly"
      libexec.install Dir["server/target/scala-*/cromwell-*.jar"][0] => "cromwell.jar"
      libexec.install Dir["womtool/target/scala-*/womtool-*.jar"][0] => "womtool.jar"
    else
      libexec.install "cromwell-#{version}.jar" => "cromwell.jar"
      resource("womtool").stage do
        libexec.install "womtool-#{version}.jar" => "womtool.jar"
      end
    end

    bin.write_jar_script libexec/"cromwell.jar", "cromwell", "$JAVA_OPTS"
    bin.write_jar_script libexec/"womtool.jar", "womtool"
  end

  test do
    (testpath/"hello.wdl").write <<~EOS
      task hello {
        String name

        command {
          echo 'hello ${name}!'
        }
        output {
          File response = stdout()
        }
      }

      workflow test {
        call hello
      }
    EOS

    (testpath/"hello.json").write <<~EOS
      {
        "test.hello.name": "world"
      }
    EOS

    result = shell_output("#{bin}/cromwell run --inputs hello.json hello.wdl")

    assert_match "test.hello.response", result
  end
end
