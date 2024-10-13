class Cromwell < Formula
  desc "Workflow Execution Engine using Workflow Description Language"
  homepage "https://github.com/broadinstitute/cromwell"
  url "https://github.com/broadinstitute/cromwell/releases/download/87/cromwell-87.jar"
  sha256 "8b6fc53d3654d32bcd15f16914d482c3aeea87fd2ed92703b937621e9d4b6a17"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "cd98a4d608af548a22962e44d83518ac11252b6cf74768c39363e822df01ed1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "127ff79e90cd39981e6309e0ef6645ff0fc1d33d1c2640f4466f5c771a00c7be"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b08cb645b23e3797922e7ccb0a5bdfb1072ecc116c86f608a15076487e6d0f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "601f14a539e23d94c91586efe6d5992a67d15dd64db6de84235062c4b98e6343"
    sha256 cellar: :any_skip_relocation, sonoma:         "b6b5aeede606de464bf916f0300c2c63ba797f8df601356492bda7e63cf9466d"
    sha256 cellar: :any_skip_relocation, ventura:        "7e488bc5ccc2808a9f908f44db07a53529ea786f3992fb59e8e2bec722e93526"
    sha256 cellar: :any_skip_relocation, monterey:       "9b08cb645b23e3797922e7ccb0a5bdfb1072ecc116c86f608a15076487e6d0f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b08cb645b23e3797922e7ccb0a5bdfb1072ecc116c86f608a15076487e6d0f8"
  end

  head do
    url "https://github.com/broadinstitute/cromwell.git", branch: "develop"
    depends_on "sbt" => :build
  end

  depends_on "openjdk"

  resource "womtool" do
    url "https://github.com/broadinstitute/cromwell/releases/download/87/womtool-87.jar"
    sha256 "73b63098ac0a87d586b7c5b8729b6e8b440de3df0f5c8b0daafd796dc4ff734c"
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

    (testpath/"hello.json").write <<~EOS
      {
        "test.hello.name": "world"
      }
    EOS

    result = shell_output("#{bin}/cromwell run --inputs hello.json hello.wdl")

    assert_match "test.hello.response", result
  end
end
