class Cromwell < Formula
  desc "Workflow Execution Engine using Workflow Description Language"
  homepage "https://github.com/broadinstitute/cromwell"
  url "https://github.com/broadinstitute/cromwell/releases/download/34/cromwell-34.jar"
  sha256 "d99749268eda20a8a236b6196905e6471a724bc5172c26a88bf4717ba40e0a4f"

  head do
    url "https://github.com/broadinstitute/cromwell.git"
    depends_on "sbt" => :build
  end

  bottle :unneeded

  depends_on :java => "1.8+"
  depends_on "akka"

  resource "womtool" do
    url "https://github.com/broadinstitute/cromwell/releases/download/34/womtool-34.jar"
    sha256 "d40b6ff942bd90425c5f79eee170ec2c52e8b011dfe4c9a323da5a6677102f5a"
  end

  def install
    if build.head?
      system "sbt", "assembly"
      libexec.install Dir["target/scala-*/cromwell-*.jar"][0]
      libexec.install Dir["womtool/target/scala-2.12/womtool-*.jar"][0]
    else
      libexec.install Dir["cromwell-*.jar"][0]
      resource("womtool").stage do
        libexec.install Dir["womtool-*.jar"][0]
      end
    end
    bin.write_jar_script Dir[libexec/"cromwell-*.jar"][0], "cromwell", "$JAVA_OPTS"
    bin.write_jar_script Dir[libexec/"womtool-*.jar"][0], "womtool"
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
