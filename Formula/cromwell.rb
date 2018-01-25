class Cromwell < Formula
  desc "Workflow Execution Engine using Workflow Description Language"
  homepage "https://github.com/broadinstitute/cromwell"
  url "https://github.com/broadinstitute/cromwell/releases/download/30.2/cromwell-30.2.jar"
  sha256 "dfdc60966807899f6a1d82c6929e26f66aecfdce0f556b8f1918a58f8e523299"

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
    else
      libexec.install Dir["cromwell-*.jar"][0]
    end
    bin.write_jar_script Dir[libexec/"cromwell-*.jar"][0], "cromwell"
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

    result = shell_output("#{bin}/cromwell run --inputs hello.json hello.wdl")

    assert_match "test.hello.response", result
  end
end
