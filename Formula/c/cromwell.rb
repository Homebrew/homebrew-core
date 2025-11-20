class Cromwell < Formula
  desc "Workflow Execution Engine using Workflow Description Language"
  homepage "https://github.com/broadinstitute/cromwell"
  url "https://github.com/broadinstitute/cromwell/releases/download/91/cromwell-91.jar"
  sha256 "a1378c7b2df9ba8e86a82adff0e2216d44d4b39a338106e4d39a5034cece4731"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4c4d24f21645c14be3422137a30674b4486bfe3d98e22f1f2f82f52b7ea34a59"
  end

  head do
    url "https://github.com/broadinstitute/cromwell.git", branch: "develop"
    depends_on "sbt" => :build
  end

  depends_on "openjdk"

  resource "womtool" do
    url "https://github.com/broadinstitute/cromwell/releases/download/91/womtool-91.jar"
    sha256 "96a6a63f3c05dba40d704665024fde88dac8cea2f2575a47c55548d3ba600390"

    livecheck do
      formula :parent
    end
  end

  def install
    odie "womtool resource needs to be updated" if build.stable? && version != resource("womtool").version

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

    (testpath/"hello.json").write <<~JSON
      {
        "test.hello.name": "world"
      }
    JSON

    result = shell_output("#{bin}/cromwell run --inputs hello.json hello.wdl")

    assert_match "test.hello.response", result
  end
end
