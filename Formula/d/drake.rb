class Drake < Formula
  desc "Data workflow tool meant to be 'make for data'"
  homepage "https://github.com/Factual/drake"
  url "https://github.com/Factual/drake/archive/refs/tags/1.0.3.tar.gz"
  sha256 "49c22b84f4059c1af905f92e276ac8a7aa80a8c236aca4c06df9b6c676b2cff7"
  license "EPL-1.0"
  head "https://github.com/Factual/drake.git", branch: "develop"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "98db9a4ae8a9345944f0b5388a35036c9a2384137f7a7db044ebc59cb5ebc117"
  end

  # Last release on 2016-04-15
  # No response to https://github.com/Factual/drake/issues/227 on project status
  deprecate! date: "2023-12-15", because: :unmaintained

  depends_on arch: :x86_64 # openjdk@8 is not supported on ARM
  depends_on "openjdk@8"

  resource "jar" do
    url "https://github.com/Factual/drake/releases/download/1.0.3/drake.jar"
    sha256 "c9c5b109a900b6f30257425feee7a4e05ef11cc34cf227b04207a2f8645316af"
  end

  def install
    jar = "drake-#{version}-standalone.jar"
    inreplace "bin/drake-pkg", "DRAKE_JAR", libexec/jar

    libexec.install "bin/drake-pkg" => "drake"
    chmod 0755, libexec/"drake"
    env = Language::Java.overridable_java_home_env("1.8")
    env["PATH"] = "$JAVA_HOME/bin:$PATH"
    (bin/"drake").write_env_script libexec/"drake", env

    resource("jar").stage do
      libexec.install "drake.jar" => jar
    end
  end

  test do
    # count lines test
    (testpath/"Drakefile").write <<~EOS
      find_lines <- [shell]
        echo 'drake' > $OUTPUT

      count_drakes_lines <- find_lines
        cat $INPUT | wc -l > $OUTPUT
    EOS

    # force run (no user prompt) the full workflow
    system bin/"drake", "--auto", "--workflow=#{testpath}/Drakefile", "+..."
  end
end
