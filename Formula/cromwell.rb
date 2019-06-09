class Cromwell < Formula
  desc "Workflow Execution Engine using Workflow Description Language"
  homepage "https://github.com/broadinstitute/cromwell"
  url "https://github.com/broadinstitute/cromwell/releases/download/42//cromwell-42.jar"
  sha256 "7fb45f7ea49cb407e965bd63e9c66fa9efff6db18206ae681288958d3c79c9a9"

  head do
    url "https://github.com/broadinstitute/cromwell.git"
    depends_on "sbt" => :build
  end

  bottle :unneeded

  depends_on :java => "1.8+"

  resource "womtool" do
    url "https://github.com/broadinstitute/cromwell/releases/download/42//womtool-42.jar"
    sha256 "c2ebf574c560d6197ac681d0e771bdc3d183b0aa133e150fd60b10ba26cf4f7e"
  end

  def install
    if build.head?
      system "sbt", "assembly"
      libexec.install Dir["server/target/scala-*/cromwell-*.jar"][0]
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
