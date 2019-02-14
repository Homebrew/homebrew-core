class Cromwell < Formula
  desc "Workflow Execution Engine using Workflow Description Language"
  homepage "https://github.com/broadinstitute/cromwell"
  url "https://github.com/broadinstitute/cromwell/releases/download/37/cromwell-37.jar"
  sha256 "605891e2c6e0c92da5382a4babcca5939b3e9ac46b1265def27a177efcd98b3b"

  head do
    url "https://github.com/broadinstitute/cromwell.git"
    depends_on "sbt" => :build
  end

  bottle :unneeded

  depends_on "akka"
  depends_on :java => "1.8+"

  resource "womtool" do
    url "https://github.com/broadinstitute/cromwell/releases/download/37/womtool-37.jar"
    sha256 "11b2410f8b76d8da8fbe1c94a5c1d8f51215a27ab25b960a9bb1719f4d29472b"
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
