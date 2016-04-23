class Geode < Formula
  desc "In-memory Data Grid for fast transactional data processing"
  homepage "https://geode.apache.org"
  url "http://apache.org/dyn/closer.cgi?filename=incubator/geode/1.0.0-incubating.M2/apache-geode-1.0.0-incubating.M2.tar.gz&action=download"
  version "1.0.0-incubating.M2"
  sha256 "8447912c6d893008dd03917722d01abff4853861ce3f34c2bc95b60c51675cea"

  bottle :unneeded
  depends_on :java

  def install
    rm_f "bin/gfsh.bat"
    bash_completion.install "bin/gfsh-completion.bash" => "gfsh"
    libexec.install Dir["*"]
    bin.write_exec_script libexec+"bin/gfsh"
  end

  def caveats; <<-EOS.undent
    Apache Geode is an effort undergoing incubation at The Apache Software Foundation (ASF),
    sponsored by the Apache Incubator. Incubation is required of all newly accepted projects until
    a further review indicates that the infrastructure, communications, and decision making process
    have stabilized in a manner consistent with other successful ASF projects. While incubation
    status is not necessarily a reflection of the completeness or stability of the code, it does
    indicate that the project has yet to be fully endorsed by the ASF.

    You may need to set JAVA_HOME:
      export JAVA_HOME="$(/usr/libexec/java_home)"
    EOS
  end

  test do
    ENV.java_cache
    output = shell_output("#{bin}/gfsh version")
    assert_match /v#{version}/, output
  end
end
