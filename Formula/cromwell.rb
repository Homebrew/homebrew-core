class Cromwell < Formula
  desc "Workflow Execution Engine using Workflow Description Language"
  homepage "https://github.com/broadinstitute/cromwell"
  url "https://github.com/broadinstitute/cromwell/releases/download/85/cromwell-85.jar"
  sha256 "100f6c61df72b4079b3ad0f03e8f73e6e2c0afe99d212ec8d42faf4bd4de1e23"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32c1c6f5ba62df9c2fa1ee21ecd00cd71f6e176cf9f481a388602beaaaad1fe2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32c1c6f5ba62df9c2fa1ee21ecd00cd71f6e176cf9f481a388602beaaaad1fe2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "32c1c6f5ba62df9c2fa1ee21ecd00cd71f6e176cf9f481a388602beaaaad1fe2"
    sha256 cellar: :any_skip_relocation, ventura:        "32c1c6f5ba62df9c2fa1ee21ecd00cd71f6e176cf9f481a388602beaaaad1fe2"
    sha256 cellar: :any_skip_relocation, monterey:       "32c1c6f5ba62df9c2fa1ee21ecd00cd71f6e176cf9f481a388602beaaaad1fe2"
    sha256 cellar: :any_skip_relocation, big_sur:        "32c1c6f5ba62df9c2fa1ee21ecd00cd71f6e176cf9f481a388602beaaaad1fe2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da037e50ee875bdc82bc99122ea830c6de4a301581ec0286deb4c677de11580c"
  end

  head do
    url "https://github.com/broadinstitute/cromwell.git", branch: "develop"
    depends_on "sbt" => :build
  end

  depends_on "openjdk"

  resource "womtool" do
    url "https://github.com/broadinstitute/cromwell/releases/download/85/womtool-85.jar"
    sha256 "53e0d6201933a5c335437dcafd62625e9f241995d450dfd1b5c0ca37a834f89b"
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
