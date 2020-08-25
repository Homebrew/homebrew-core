class Cromwell < Formula
  desc "Workflow Execution Engine using Workflow Description Language"
  homepage "https://github.com/broadinstitute/cromwell"
  url "https://github.com/broadinstitute/cromwell/releases/download/53//cromwell-53.jar"
  sha256 "e400087ed0807b68fac87769cf742ad46195c13f5bf96a7a68a0ff099d2f169e"
  license "BSD-3-Clause"

  head do
    url "https://github.com/broadinstitute/cromwell.git"
    depends_on "sbt" => :build
  end

  bottle :unneeded

  depends_on "openjdk"

  resource "womtool" do
    url "https://github.com/broadinstitute/cromwell/releases/download/53//womtool-53.jar"
    sha256 "295b7c9345f8572a781e11d7bd93b5b22888d1cb82fc981ed3d8b95d7f86f664"
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

    (bin/"cromwell").write <<~EOS
      #!/bin/bash
      exec "#{Formula["openjdk"].opt_bin}/java" $JAVA_OPTS -jar "#{libexec}/cromwell.jar" "$@"
    EOS
    (bin/"womtool").write <<~EOS
      #!/bin/bash
      exec "#{Formula["openjdk"].opt_bin}/java" -jar "#{libexec}/womtool.jar" "$@"
    EOS
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
