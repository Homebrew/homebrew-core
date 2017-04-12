class Cromwell < Formula
  desc "Workflow Execution Engine using Workflow Description Language"
  homepage "https://github.com/broadinstitute/cromwell"
  url "https://github.com/broadinstitute/cromwell/releases/download/26/cromwell-26.jar"
  sha256 "f1a77b3f37b089d92468b94d5c3f65c8a8d9b8081794546068517ea055ac2c20"

  head do
    url "https://github.com/broadinstitute/cromwell.git"
    depends_on "sbt" => :build
  end

  bottle :unneeded

  depends_on :java => "1.8+"
  depends_on "akka"

  def install
    if build.head?
      system "sbt", "assembly"
      libexec.install Dir["target/scala-*/cromwell-*.jar"][0]
      bin.write_jar_script Dir[libexec/"cromwell-*.jar"][0], "cromwell"
    else
      libexec.install "cromwell-#{version}.jar"
      bin.write_jar_script libexec/"cromwell-#{version}.jar", "cromwell"
    end
  end

  test do
    (testpath/"hello.wdl").write <<-EOS
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

    (testpath/"hello.json").write <<-EOS
      {
        "test.hello.name": "world"
      }
    EOS

    result = shell_output("#{bin}/cromwell run hello.wdl hello.json")

    assert_match "test.hello.response", result
  end
end
