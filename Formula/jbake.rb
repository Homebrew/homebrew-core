class Jbake < Formula
  desc "Java based static site/blog generator"
  homepage "http://jbake.org"
  url "http://jbake.org/files/jbake-2.5.0-bin.zip"
  sha256 "95f0d218eff9ea545ce58b15dae5fe4386469c9697db92ff22553edddcbdfd74"

  bottle :unneeded

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install Dir["*"]
    bin.write_jar_script "#{libexec}/jbake-core.jar", "jbake"
  end
end
