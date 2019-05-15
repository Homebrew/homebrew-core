class Cromwell < Formula
  desc "Workflow Execution Engine using Workflow Description Language"
  homepage "https://github.com/broadinstitute/cromwell"
  url "https://github.com/broadinstitute/cromwell/releases/download/41/cromwell-41.jar"
  sha256 "a4cade2008858e6d088f2123c2026f2cc90e02fffee12b36c40be8ace235776d"

  head do
    url "https://github.com/broadinstitute/cromwell.git"
    depends_on "sbt" => :build
  end

  bottle :unneeded

  depends_on :java => "1.8+"

  resource "womtool" do
    url "https://github.com/broadinstitute/cromwell/releases/download/41/womtool-41.jar"
    sha256 "d4c0f6130862fa57b0bc253772cfb9b59148d1e438c66ab6d9ce3773dd89d8ec"
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
