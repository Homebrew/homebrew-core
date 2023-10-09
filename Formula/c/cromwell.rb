class Cromwell < Formula
  desc "Workflow Execution Engine using Workflow Description Language"
  homepage "https://github.com/broadinstitute/cromwell"
  url "https://github.com/broadinstitute/cromwell/releases/download/86/cromwell-86.jar"
  sha256 "f9581657e0484c90b5ead0f699d8d791f94e3cabe87d8cb0c5bfb21d1fdb6592"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b5eed7da2e3b9fafb57228d55b1983ac3084e9b98cc67d1aecb91564d6c9efac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b5eed7da2e3b9fafb57228d55b1983ac3084e9b98cc67d1aecb91564d6c9efac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5eed7da2e3b9fafb57228d55b1983ac3084e9b98cc67d1aecb91564d6c9efac"
    sha256 cellar: :any_skip_relocation, sonoma:         "b5eed7da2e3b9fafb57228d55b1983ac3084e9b98cc67d1aecb91564d6c9efac"
    sha256 cellar: :any_skip_relocation, ventura:        "b5eed7da2e3b9fafb57228d55b1983ac3084e9b98cc67d1aecb91564d6c9efac"
    sha256 cellar: :any_skip_relocation, monterey:       "b5eed7da2e3b9fafb57228d55b1983ac3084e9b98cc67d1aecb91564d6c9efac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4ddd4a9855e576c277d134b56776f832f3243239bcef0136e98f52d1923266f"
  end

  head do
    url "https://github.com/broadinstitute/cromwell.git", branch: "develop"
    depends_on "sbt" => :build
  end

  depends_on "openjdk"

  resource "womtool" do
    url "https://github.com/broadinstitute/cromwell/releases/download/86/womtool-86.jar"
    sha256 "5212a139755cd299ad61324429a3319bf0d2c5c4966e4270dd90579a4f84c0d8"
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
